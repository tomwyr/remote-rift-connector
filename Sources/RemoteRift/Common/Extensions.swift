import Foundation
import Hummingbird
import HummingbirdWebSocket

extension AsyncStream {
  init(
    every interval: Duration,
    _ computation: @escaping @Sendable () async -> Element,
  ) {
    self.init { continuation in
      let task = Task {
        while !Task.isCancelled {
          try? await Task.sleep(for: interval)
          continuation.yield(await computation())
        }
      }
      continuation.onTermination = { term in
        task.cancel()
      }
    }
  }
}

extension Encodable {
  func jsonEncoded() throws -> String {
    let jsonData = try JSONEncoder().encode(self)
    guard let jsonString = String(data: jsonData, encoding: .utf8) else {
      let context = EncodingError.Context(
        codingPath: [],
        debugDescription: "Encodable data cannot be converted to string",
      )
      throw EncodingError.invalidValue(self, context)
    }
    return jsonString
  }
}

extension RouterGroup<BasicWebSocketRequestContext> {
  @discardableResult func wsOutSafe(
    _ path: RouterPath = "",
    resolve: @escaping @Sendable (WebSocketOutboundWriter) async throws -> Void
  ) -> RouterGroup<BasicWebSocketRequestContext> {
    ws(path) { _, _ in
      .upgrade()
    } onUpgrade: { inbound, outbound, sd in
      func processInput() async throws {
        for try await _ in inbound {
          // Read inbound data to keep the ping-pong connection alive.
        }
      }

      await withTaskGroup { group in
        group.addTask {
          do {
            try await resolve(outbound)
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
  }
}
