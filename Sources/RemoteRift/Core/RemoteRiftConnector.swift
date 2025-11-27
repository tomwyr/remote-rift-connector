import Foundation

struct RemoteRiftConnector {
  init(lcuApi: LcuApiClient) {
    self.lcuApi = lcuApi
  }

  private let lcuApi: LcuApiClient

  func getStatusStream() -> AsyncStream<RemoteRiftResponse<RemoteRiftStatus>> {
    AsyncStream(every: .seconds(1)) {
      await _runCatching {
        let connection = try await lcuApi.getHeartbeatConnection()
        return connection.stableConnection ? .ready : .unavailable
      }
    }
  }

  func getCurrentSateStream() -> AsyncStream<RemoteRiftState> {
    AsyncStream(every: .seconds(1)) {
      try? await self.getCurrentState()
    }.removingDuplicates()
  }

  func getCurrentState() async throws -> RemoteRiftState {
    let gameflowPhase = try await lcuApi.getGameflowPhase()

    switch gameflowPhase {
    case .none:
      return .preGame

    case .lobby:
      return .lobby(state: .idle)

    case .matchmaking:
      let matchmakingSearch = try await lcuApi.getMatchmakingSearch()

      return switch matchmakingSearch.state {
      case .invalid:
        .unknown
      case .searching:
        .lobby(state: .searching)
      case .found:
        .unknown
      }

    case .readyCheck:
      let readyCheck = try await lcuApi.getReadyCheck()

      return switch readyCheck.state {
      case .invalid:
        .unknown

      case .inProgress:
        switch readyCheck.playerResponse {
        case .none:
          .found(state: .pending)
        case .accepted:
          .found(state: .accepted)
        case .declined:
          .found(state: .declined)
        }
      }

    case .champSelect, .inProgress, .preEndOfGame, .endOfGame:
      return .inGame
    }
  }

  func createLobby() async throws {
    guard case .preGame = try await getCurrentState() else {
      throw RemoteRiftError.notPreGame
    }
    try await lcuApi.createLobby()
  }

  func leaveLobby() async throws {
    guard case .lobby(state: .idle) = try await getCurrentState() else {
      throw RemoteRiftError.notIdleState
    }
    try await lcuApi.deleteLobby()
  }

  func searchMatch() async throws {
    guard case .lobby(state: .idle) = try await getCurrentState() else {
      throw RemoteRiftError.notIdleState
    }
    try await lcuApi.startMatchmakingSearch()
  }

  func stopMatchSearch() async throws {
    guard case .lobby(state: .searching) = try await getCurrentState() else {
      throw RemoteRiftError.notSearchingState
    }
    try await lcuApi.stopMatchmakingSearch()
  }

  func acceptMatch() async throws {
    guard case .found(state: .pending) = try await getCurrentState() else {
      throw RemoteRiftError.notPendingState
    }
    try await lcuApi.acceptReadyCheck()
  }

  func declineMatch() async throws {
    guard case .found(state: .pending) = try await getCurrentState() else {
      throw RemoteRiftError.notPendingState
    }
    try await lcuApi.declineReadyCheck()
  }

  func _runCatching<T>(resolve: () async throws -> T) async -> RemoteRiftResponse<T>
  where T: ResponseCodable {
    do {
      return .data(try await resolve())
    } catch  where error.isConnectionError {
      return .error(.unableToConnect)
    } catch {
      return .error(.unknown)
    }
  }

}

enum RemoteRiftError: Error {
  case notPreGame
  case notIdleState
  case notSearchingState
  case notPendingState
}
