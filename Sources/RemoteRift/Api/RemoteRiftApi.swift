import ArgumentParser
import Foundation
import Hummingbird
import HummingbirdWebSocket
import Logging

struct RemoteRiftApi {
  func runService(host: String, port: Int) async throws {
    let router = Router.webSocketSupported().configure()

    let app = Application(
      router: router,
      server: .http1WebSocketUpgrade(webSocketRouter: router),
      configuration: .init(address: .hostname(host, port: port))
    )

    try await app.runService()
  }
}
