import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'lcu_connection.dart';
import 'lcu_models.dart';

class LcuApiClient {
  LcuApiClient({required this.lcuConnection, required this.httpClient});

  final LcuConnection lcuConnection;
  final Client httpClient;

  static const _rankedSoloQueueId = 420;

  Future<HeartbeatConnection> getHeartbeatConnection() async {
    final response = await _request(.post, 'lol-heartbeat/v1/connection-status');
    return .fromJson(jsonDecode(response.body));
  }

  Future<GameflowPhase> getGameflowPhase() async {
    final response = await _request(.get, 'lol-gameflow/v1/gameflow-phase');
    return .fromJson(jsonDecode(response.body));
  }

  Future<void> createLobby() async {
    await _request(.post, 'lol-lobby/v2/lobby', {'queueId': _rankedSoloQueueId});
  }

  Future<void> deleteLobby() async {
    await _request(.delete, 'lol-lobby/v2/lobby');
  }

  Future<MatchmakingSearch> getMatchmakingSearch() async {
    final response = await _request(.get, 'lol-lobby/v2/lobby/matchmaking/search-state');
    return .fromJson(jsonDecode(response.body));
  }

  Future<void> startMatchmakingSearch() async {
    await _request(.post, 'lol-lobby/v2/lobby/matchmaking/search');
  }

  Future<void> stopMatchmakingSearch() async {
    await _request(.delete, 'lol-lobby/v2/lobby/matchmaking/search');
  }

  Future<ReadyCheck> getReadyCheck() async {
    final response = await _request(.get, 'lol-matchmaking/v1/ready-check');
    if (response.isSuccessful) {
      return .fromJson(jsonDecode(response.body));
    } else {
      throw ReadyCheckError.fromJson(jsonDecode(response.body));
    }
  }

  Future<void> acceptReadyCheck() async {
    await _request(.post, 'lol-matchmaking/v1/ready-check/accept');
  }

  Future<void> declineReadyCheck() async {
    await _request(.post, 'lol-matchmaking/v1/ready-check/decline');
  }

  Future<Response> _request(HttpMethod method, String path, [Map<String, dynamic>? body]) async {
    Future<Response> execute() async {
      final lockfileData = lcuConnection.getLockfileData();
      return await _runRequest(method, path, body, lockfileData);
    }

    try {
      return await execute();
    } catch (error) {
      if (error case Exception(isLockfileError: true)) rethrow;
      // Retry once in case the error was caused by stale lockfile
      lcuConnection.refreshLockfileData();
      return await execute();
    }
  }

  Future<Response> _runRequest(
    HttpMethod method,
    String path,
    Map<String, dynamic>? body,
    LcuLockfileData lockfileData,
  ) async {
    final baseUrl = 'https://127.0.0.1:${lockfileData.port}';
    final url = Uri.parse('$baseUrl/$path');

    final credentials = 'riot:${lockfileData.password}';
    final authorization = base64Encode(utf8.encode(credentials));

    final headers = {'Authorization': 'Basic $authorization', 'Content-Type': 'application/json'};

    return await switch (method) {
      .get => httpClient.get(url, headers: headers),
      .post => httpClient.post(url, headers: headers, body: jsonEncode(body)),
      .delete => httpClient.delete(url, headers: headers),
    };
  }
}

enum HttpMethod { get, post, delete }

extension on Response {
  bool get isSuccessful {
    return statusCode >= 200 && statusCode < 300;
  }
}

extension ErrorExtensions on Exception {
  bool get isLockfileError {
    return this is SocketException;
  }

  bool get isConnectionError {
    return this is LcuConnectionError || this is SocketException;
  }
}
