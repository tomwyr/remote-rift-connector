import 'dart:math';

import 'package:remote_rift_utils/remote_rift_utils.dart';

import 'common/http_client.dart';
import 'lcu/lcu_api_client.dart';
import 'lcu/lcu_connection.dart';
import 'mappers/queue.dart';
import 'models/queue.dart';
import 'models/response.dart';
import 'models/session.dart';
import 'models/state.dart';
import 'models/status.dart';

class RemoteRiftConnector {
  factory RemoteRiftConnector() {
    return RemoteRiftConnector._init(
      lcuApi: LcuApiClient(
        lcuConnection: LcuConnection(parser: LcuLockfileParser(), loader: LcuLockfileLoader()),
        httpClient: ClientFactory.noCertificateVerification(),
      ),
    );
  }

  RemoteRiftConnector._init({required this.lcuApi});

  final LcuApiClient lcuApi;

  static const _readyCheckMaxTimeSeconds = 10.0;

  Stream<RemoteRiftResponse<RemoteRiftStatus>> getStatusStream() async* {
    await for (var _ in _tickStream(seconds: 1)) {
      yield await _runCatching(() async {
        final connection = await lcuApi.getHeartbeatConnection();
        return connection.stableConnection ? .ready : .unavailable;
      });
    }
  }

  Stream<RemoteRiftSession> getCurrentSessionStream() async* {
    RemoteRiftSession? previousSession;
    await for (var _ in _tickStream(seconds: 1)) {
      if (await _getCurrentSession() case var session when session != previousSession) {
        yield session;
        previousSession = session;
      }
    }
  }

  Future<RemoteRiftSession> _getCurrentSession() async {
    var (queueName, state) = await (_getQueueNameOrNull(), _getCurrentState()).wait;
    if (state case PreGame()) {
      // Clear the queue if the session data is out of sync with the state.
      queueName = null;
    }
    return RemoteRiftSession(queueName: queueName, state: state);
  }

  Future<String?> _getQueueNameOrNull() async {
    try {
      final session = await lcuApi.getGameflowSession();
      return session.gameData.queue.description;
    } catch (_) {
      return null;
    }
  }

  Future<RemoteRiftState> _getCurrentState() async {
    final gameflowPhase = await lcuApi.getGameflowPhase();
    switch (gameflowPhase) {
      case .none:
        final availableQueues = await _getAvailableQueues();
        return PreGame(availableQueues: availableQueues);

      case .lobby:
        return Lobby(state: .idle);

      case .matchmaking:
        final matchmakingSearch = await lcuApi.getMatchmakingSearch();
        return switch (matchmakingSearch.searchState) {
          .searching => Lobby(state: .searching),
          .found || .invalid => Unknown(),
        };

      case .readyCheck:
        final readyCheck = await lcuApi.getReadyCheck();
        switch (readyCheck.state) {
          case .inProgress:
            final GameFoundState state = switch (readyCheck.playerResponse) {
              .none => .pending,
              .accepted => .accepted,
              .declined => .declined,
            };
            final answerTimeLeft = max(_readyCheckMaxTimeSeconds - readyCheck.timer, 0.0);
            return Found(
              state: state,
              answerMaxTime: _readyCheckMaxTimeSeconds,
              answerTimeLeft: answerTimeLeft,
            );

          case .invalid:
            return Unknown();
        }

      case .champSelect || .inProgress || .waitingForStats || .preEndOfGame || .endOfGame:
        return InGame();
    }
  }

  Future<List<GameQueue>> _getAvailableQueues() async {
    final queues = await lcuApi.getGameQueues();
    return queues
        .where(GameQueueFilter.shouldDisplay)
        .map(GameQueueMapper.fromLcu)
        .toList();
  }

  Future<void> createLobby({required int queueId}) async {
    if (await _getCurrentState() case PreGame()) {
      await lcuApi.createLobby(queueId: queueId);
    } else {
      throw RemoteRiftStateError.notPreGame;
    }
  }

  Future<void> leaveLobby() async {
    if (await _getCurrentState() case Lobby(state: .idle)) {
      await lcuApi.deleteLobby();
    } else {
      throw RemoteRiftStateError.notIdleState;
    }
  }

  Future<void> searchMatch() async {
    if (await _getCurrentState() case Lobby(state: .idle)) {
      await lcuApi.startMatchmakingSearch();
    } else {
      throw RemoteRiftStateError.notIdleState;
    }
  }

  Future<void> stopMatchSearch() async {
    if (await _getCurrentState() case Lobby(state: .searching)) {
      await lcuApi.stopMatchmakingSearch();
    } else {
      throw RemoteRiftStateError.notSearchingState;
    }
  }

  Future<void> acceptMatch() async {
    if (await _getCurrentState() case Found(state: .pending)) {
      await lcuApi.acceptReadyCheck();
    } else {
      throw RemoteRiftStateError.notPendingState;
    }
  }

  Future<void> declineMatch() async {
    if (await _getCurrentState() case Found(state: .pending)) {
      await lcuApi.declineReadyCheck();
    } else {
      throw RemoteRiftStateError.notPendingState;
    }
  }

  Stream<void> _tickStream({required int seconds}) {
    return .periodic(Duration(seconds: seconds)).startWith(null);
  }

  Future<RemoteRiftResponse<T>> _runCatching<T>(Future<T> Function() resolve) async {
    try {
      return RemoteRiftData(await resolve());
    } catch (error) {
      if (error case LcuConnectionError() || LcuApiClientError()) {
        return RemoteRiftError.unableToConnect;
      } else {
        return RemoteRiftError.unknown;
      }
    }
  }
}

enum RemoteRiftStateError implements Exception {
  notPreGame,
  notIdleState,
  notSearchingState,
  notPendingState,
}
