import Hummingbird
import UnionCodable

@UnionCodable
enum RemoteRiftStateResponse: Equatable, Codable {
  case data(RemoteRiftState)
  case error(RemoteRiftStateError)
}

@UnionCodable(discriminator: "value")
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

@UnionCodable(discriminator: "value")
enum RemoteRiftStateError: Error, Codable {
  case unableToConnect
  case unknown
}
