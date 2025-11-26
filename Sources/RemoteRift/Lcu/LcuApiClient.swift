import Foundation

struct LcuApiClient {
  init(httpClient: HttpClient, lcuConnection: LcuConnection) {
    self.httpClient = httpClient
    self.lcuConnection = lcuConnection
  }

  private let httpClient: HttpClient
  private let lcuConnection: LcuConnection

  private let rankedSoloQueueId = 420

  func getHeartbeatConnection() async throws -> HeartbeatConnection {
    let (data, _) = try await request(.post, "lol-heartbeat/v1/connection-status")
    return try data.jsonDecoded()
  }

  func getGameflowPhase() async throws -> GameflowPhase {
    let (data, _) = try await request(.get, "lol-gameflow/v1/gameflow-phase")
    return try data.jsonDecoded()
  }

  func createLobby() async throws {
    let (_, _) = try await request(
      .post, "lol-lobby/v2/lobby",
      ["queueId": rankedSoloQueueId],
    )
  }

  func deleteLobby() async throws {
    let (_, _) = try await request(.delete, "lol-lobby/v2/lobby")
  }

  func getMatchmakingSearch() async throws -> MatchmakingSearch {
    let (data, _) = try await request(.get, "lol-lobby/v2/lobby/matchmaking/search-state")
    return try data.jsonDecoded()
  }

  func startMatchmakingSearch() async throws {
    let (_, _) = try await request(.post, "lol-lobby/v2/lobby/matchmaking/search")
  }

  func stopMatchmakingSearch() async throws {
    let (_, _) = try await request(.delete, "lol-lobby/v2/lobby/matchmaking/search")
  }

  func getReadyCheck() async throws -> ReadyCheck {
    let (data, response) = try await request(.get, "lol-matchmaking/v1/ready-check")
    if response.isSuccessful {
      return try data.jsonDecoded()
    } else {
      throw try data.jsonDecoded(into: ReadyCheckError.self)
    }
  }

  func acceptReadyCheck() async throws {
    let (_, _) = try await request(.post, "lol-matchmaking/v1/ready-check/accept")
  }

  func declineReadyCheck() async throws {
    let (_, _) = try await request(.post, "lol-matchmaking/v1/ready-check/decline")
  }

  private func request(
    _ method: HttpMethod, _ path: String,
    _ body: [String: Any]? = nil,
  ) async throws -> (Data, HTTPURLResponse) {
    let execute = {
      let lockfileData = try await lcuConnection.getLockfileData()
      return try await requestHttp(method, path, body, lockfileData)
    }

    do {
      return try await execute()
    } catch  where error.isLockfileError {
      // Retry once in case the error was caused by stale lockfile
      _ = try await lcuConnection.refreshLockfileData()
      return try await execute()
    }
  }

  private func requestHttp(
    _ method: HttpMethod, _ path: String,
    _ body: [String: Any]? = nil,
    _ lockfileData: LcuLockfileData,
  ) async throws -> (Data, HTTPURLResponse) {
    let baseUrl = "https://127.0.0.1:\(lockfileData.port)"

    let credentials = "riot:\(lockfileData.password)"
    let authorization = credentials.data(using: .utf8)!.base64EncodedString()

    return try await httpClient.request(
      url: "\(baseUrl)/\(path)",
      method: method,
      headers: [
        "Authorization": "Basic \(authorization)",
        "Content-Type": "application/json",
      ],
      body: body,
    )
  }
}

extension Error {
  var isLockfileError: Bool {
    self is URLError
  }

  var isConnectionError: Bool {
    switch self {
    case is URLError, is LcuConnectionError:
      true
    default:
      false
    }
  }
}
