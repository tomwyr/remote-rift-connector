import Foundation
import Hummingbird
import HummingbirdWebSocket
import Logging

extension Router where Context == BasicWebSocketRequestContext {
  static func webSocketSupported() -> Router {
    .init(context: BasicWebSocketRequestContext.self)
  }

  func configure() -> Self {
    let state = group("state")

    state.get("current") { req, res async throws in
      let state = try await RemoteRift().getCurrentState()
      return JsonResponseGenerator(value: state)
    }

    state.ws("watch") { _, _ in
      .upgrade()
    } onUpgrade: { inbound, outbound, sd in
      func streamCurrentState() async throws {
        for await state in try RemoteRift().getCurrentSateStream() {
          let json = try state.jsonEncoded()
          try await outbound.write(.text(json))
        }
      }

      func processInput() async throws {
        for try await _ in inbound {
          // Read inbound data to keep the ping-pong connection alive.
        }
      }

      await withTaskGroup { group in
        group.addTask {
          do {
            try await streamCurrentState()
          } catch {
            print("Outbound error:", error)
          }
        }

        group.addTask {
          do {
            try await processInput()
          } catch {
            print("Inbound error:", error)
          }
        }
      }
    }

    let queue = group("queue")

    queue.post("start") { req, res async throws in
      try await RemoteRift().searchMatch()
      return HTTPResponse.Status.noContent
    }

    queue.post("stop") { req, res async throws in
      try await RemoteRift().stopMatchSearch()
      return HTTPResponse.Status.noContent
    }

    queue.post("accept") { req, res async throws in
      try await RemoteRift().acceptMatch()
      return HTTPResponse.Status.noContent
    }

    queue.post("decline") { req, res async throws in
      try await RemoteRift().declineMatch()
      return HTTPResponse.Status.noContent
    }

    return self
  }
}

extension RemoteRift {
  init() throws {
    let connection = LcuConnection()
    let lockfileData = try connection.getLockfileData()
    let lcuApi = LcuApiClient(httpClient: .noCertificateVerification(), lockfileData: lockfileData)
    self.init(lcuApi: lcuApi)
  }
}
