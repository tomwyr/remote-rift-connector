import 'common/http_client.dart';
import 'extensions.dart';
import 'lcu/lcu_api_client.dart';
import 'lcu/lcu_connection.dart';
import 'models.dart';

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

  Stream<RemoteRiftResponse<RemoteRiftStatus>> getStatusStream() async* {
    await for (var _ in _tickStream(seconds: 1)) {
      yield await _runCatching(() async {
        final connection = await lcuApi.getHeartbeatConnection();
        return connection.stableConnection ? .ready : .unavailable;
      });
    }
  }

  Stream<RemoteRiftState> getCurrentSateStream() async* {
    RemoteRiftState? previousState;
    await for (var _ in _tickStream(seconds: 1)) {
      if (await getCurrentState() case var state when state != previousState) {
        yield state;
        previousState = state;
      }
    }
  }

  Future<RemoteRiftState> getCurrentState() async {
    final gameflowPhase = await lcuApi.getGameflowPhase();
    switch (gameflowPhase) {
      case .none:
        return PreGame();

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
        return switch (readyCheck.state) {
          .inProgress => switch (readyCheck.playerResponse) {
            .none => Found(state: .pending),
            .accepted => Found(state: .accepted),
            .declined => Found(state: .declined),
          },
          .invalid => Unknown(),
        };

      case .champSelect || .inProgress || .waitingForStats || .preEndOfGame || .endOfGame:
        return InGame();
    }
  }

  Future<void> createLobby() async {
    if (await getCurrentState() case PreGame()) {
      await lcuApi.createLobby();
    } else {
      throw RemoteRiftStateError.notPreGame;
    }
  }

  Future<void> leaveLobby() async {
    if (await getCurrentState() case Lobby(state: .idle)) {
      await lcuApi.deleteLobby();
    } else {
      throw RemoteRiftStateError.notIdleState;
    }
  }

  Future<void> searchMatch() async {
    if (await getCurrentState() case Lobby(state: .idle)) {
      await lcuApi.startMatchmakingSearch();
    } else {
      throw RemoteRiftStateError.notIdleState;
    }
  }

  Future<void> stopMatchSearch() async {
    if (await getCurrentState() case Lobby(state: .searching)) {
      await lcuApi.stopMatchmakingSearch();
    } else {
      throw RemoteRiftStateError.notSearchingState;
    }
  }

  Future<void> acceptMatch() async {
    if (await getCurrentState() case Found(state: .pending)) {
      await lcuApi.acceptReadyCheck();
    } else {
      throw RemoteRiftStateError.notPendingState;
    }
  }

  Future<void> declineMatch() async {
    if (await getCurrentState() case Found(state: .pending)) {
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
