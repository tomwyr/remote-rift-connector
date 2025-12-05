import Foundation

enum GameflowPhase: String, Codable {
  case none = "None"
  case lobby = "Lobby"
  case matchmaking = "Matchmaking"
  case readyCheck = "ReadyCheck"
  case champSelect = "ChampSelect"
  case inProgress = "InProgress"
  case waitingForStats = "WaitingForStats"
  case preEndOfGame = "PreEndOfGame"
  case endOfGame = "EndOfGame"
}

struct MatchmakingSearch: Codable {
  let state: MatchmakingSearchState

  enum CodingKeys: String, CodingKey {
    case state = "searchState"
  }
}

enum MatchmakingSearchState: String, Codable {
  case invalid = "Invalid"
  case searching = "Searching"
  case found = "Found"
}

struct ReadyCheck: Codable {
  let state: ReadyCheckState
  let timer: Double
  let playerResponse: ReadyCheckResponse
}

enum ReadyCheckState: String, Codable {
  case invalid = "Invalid"
  case inProgress = "InProgress"
}

enum ReadyCheckResponse: String, Codable {
  case none = "None"
  case accepted = "Accepted"
  case declined = "Declined"
}

struct ReadyCheckError: Error, Codable {
  let httpStatus: Int
  let message: String
}

struct HeartbeatConnection: Codable {
  let stableConnection: Bool
}
