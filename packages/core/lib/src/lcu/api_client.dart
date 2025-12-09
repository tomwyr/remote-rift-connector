import 'dart:convert';

import 'package:http/http.dart';

import 'connection.dart';
import 'models.dart';

class LcuApiClient {
  LcuApiClient({required this.lcuConnection, required this.httpClient});

  final LcuConnection lcuConnection;
  final Client httpClient;

  static const _rankedSoloQueueId = 420;

  Future<HeartbeatConnection> getHeartbeatConnection() async {
    final response = await request(.post, 'lol-heartbeat/v1/connection-status');
    return .fromJson(jsonDecode(response.body));
  }

  Future<GameflowPhase> getGameflowPhase() async {
    final response = await request(.get, 'lol-gameflow/v1/gameflow-phase');
    return .fromJson(response.body);
  }

  Future<void> createLobby() async {
    await request(.post, 'lol-lobby/v2/lobby', {'queueId': _rankedSoloQueueId});
  }

  Future<void> deleteLobby() async {
    await request(.delete, 'lol-lobby/v2/lobby');
  }

  Future<MatchmakingSearch> getMatchmakingSearch() async {
    final response = await request(.get, 'lol-lobby/v2/lobby/matchmaking/search-state');
    return .fromJson(jsonDecode(response.body));
  }

  Future<void> startMatchmakingSearch() async {
    await request(.post, 'lol-lobby/v2/lobby/matchmaking/search');
  }

  Future<void> stopMatchmakingSearch() async {
    await request(.delete, 'lol-lobby/v2/lobby/matchmaking/search');
  }

  Future<ReadyCheck> getReadyCheck() async {
    final response = await request(.get, 'lol-matchmaking/v1/ready-check');
    if (response.isSuccessful) {
      return .fromJson(jsonDecode(response.body));
    } else {
      throw ReadyCheckError.fromJson(jsonDecode(response.body));
    }
  }

  Future<void> acceptReadyCheck() async {
    await request(.post, 'lol-matchmaking/v1/ready-check/accept');
  }

  Future<void> declineReadyCheck() async {
    await request(.post, 'lol-matchmaking/v1/ready-check/decline');
  }

  Future<Response> request(HttpMethod method, String path, [Map<String, dynamic>? body]) async {
    Future<Response> execute() async {
      final lockfileData = lcuConnection.getLockfileData();
      return await requestHttp(method, path, body, lockfileData);
    }

    try {
      return await execute();
    } catch (error) {
      if (!error.isLockfileError) rethrow;
      // Retry once in case the error was caused by stale lockfile
      lcuConnection.refreshLockfileData();
      return await execute();
    }
  }

  Future<Response> requestHttp(
    HttpMethod method,
    String path,
    Map<String, dynamic>? body,
    LcuLockfileData lockfileData,
  ) async {
    const baseUrl = 'https://127.0.0.1:(lockfileData.port)';
    final url = Uri.parse('$baseUrl/$path');

    final credentials = 'riot:${lockfileData.password}';
    final authorization = base64Encode(utf8.encode(credentials));

    final headers = {'Authorization': 'Basic $authorization', 'Content-Type': 'application/json'};

    switch (method) {
      case .get:
        return get(url, headers: headers);
      case .post:
        return post(url, headers: headers, body: body);
      case .delete:
        return delete(url, headers: headers);
    }
  }
}

enum HttpMethod { get, post, delete }

extension on Response {
  bool get isSuccessful {
    return statusCode >= 200 && statusCode < 300;
  }
}

extension ErrorExtensions on Object {
  bool get isLockfileError {
    // self is URLError
    return false;
  }

  bool get isConnectionError {
    // switch self {
    // case is URLError, is LcuConnectionError:
    //   true
    // default:
    //   false
    // }
    return false;
  }
}
