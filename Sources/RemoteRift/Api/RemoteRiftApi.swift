import Foundation
import Hummingbird
import HummingbirdWebSocket
import Logging

@main
struct RemoteRiftApi {
  static func main() async throws {
    let router = Router.webSocketSupported().configure()

    let app = Application(
      router: router,
      server: .http1WebSocketUpgrade(webSocketRouter: router),
      configuration: .init(address: .hostname("192.168.50.252", port: 8080))
    )

    try await app.runService()
  }
}
