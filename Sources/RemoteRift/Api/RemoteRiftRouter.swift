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
      let controller = RemoteRiftController()
      let state = try await controller.getCurrentState()
      return JsonResponseGenerator(value: state)
    }

    state.ws("watch") { _, _ in
      .upgrade()
    } onUpgrade: { inbound, outbound, sd in
      func streamCurrentState() async throws {
        let controller = RemoteRiftController()
        for await state in try controller.getCurrentSateStream() {
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

    return self
  }
}
