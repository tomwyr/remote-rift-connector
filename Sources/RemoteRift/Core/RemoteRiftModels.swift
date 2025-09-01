import Hummingbird
import UnionCodable

@UnionCodable
enum RemoteRiftState: Equatable, Codable {
  case unknown
  case preGame
  case lobby(state: GameLobbyState)
  case found(state: GameFoundState)
  case inGame
}

enum GameLobbyState: String, Codable {
  case idle
  case searching
}

enum GameFoundState: String, Codable {
  case pending
  case accepted
  case declined
}
