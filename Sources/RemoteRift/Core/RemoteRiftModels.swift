import Hummingbird
import UnionCodable

@UnionCodable
enum RemoteRiftStateResponse: Equatable, ResponseCodable {
  case data(RemoteRiftState)
  case error(RemoteRiftStateError)
}

@UnionCodable(discriminator: "value")
enum RemoteRiftState: Equatable, ResponseCodable {
  case unknown
  case preGame
  case lobby(state: GameLobbyState)
  case found(state: GameFoundState)
  case inGame
}

enum GameLobbyState: String, ResponseCodable {
  case idle
  case searching
}

enum GameFoundState: String, ResponseCodable {
  case pending
  case accepted
  case declined
}

@UnionCodable(discriminator: "value")
enum RemoteRiftStateError: Error, ResponseCodable {
  case unableToConnect
  case unknown
}
