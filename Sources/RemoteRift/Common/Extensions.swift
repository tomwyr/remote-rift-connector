import Foundation
import Hummingbird
import HummingbirdWebSocket
import ServiceLifecycle

extension AsyncStream {
  init(
    every interval: Duration,
    _ computation: @escaping @Sendable () async -> Element,
  ) {
    self.init { continuation in
      let task = Task {
        await withGracefulShutdownHandler {
          while !Task.isCancelled {
            try? await Task.sleep(for: interval)
            continuation.yield(await computation())
          }
        } onGracefulShutdown: {
          continuation.finish()
        }
      }
      continuation.onTermination = { term in
        task.cancel()
      }
    }
  }
}

extension AsyncStream where Element: Equatable & Sendable {
  func removeDuplicates() -> AsyncStream<Element> {
    .init { continuation in
      let task = Task {
        var last: Element?
        for await value in self {
          if last != value {
            last = value
            continuation.yield(value)
          }
        }
        continuation.finish()
      }
      continuation.onTermination = { term in
        task.cancel()
      }
    }
  }
}

extension AsyncThrowingStream where Failure == Error {
  init(
    every interval: Duration,
    _ computation: @escaping @Sendable () async throws -> Element,
  ) {
    self.init { continuation in
      let task = Task {
        await withGracefulShutdownHandler {
          while !Task.isCancelled {
            try? await Task.sleep(for: interval)
            do {
              let value = try await computation()
              continuation.yield(value)
            } catch {
              continuation.finish(throwing: error)
              break
            }
          }
        } onGracefulShutdown: {
          continuation.finish()
        }
      }
      continuation.onTermination = { term in
        task.cancel()
      }
    }
  }
}

extension AsyncThrowingStream where Element: Equatable & Sendable, Failure == Error {
  func removeDuplicates() -> AsyncThrowingStream<Element, Failure> {
    .init { continuation in
      let task = Task {
        do {
          var last: Element?
          for try await value in self {
            if last != value {
              last = value
              continuation.yield(value)
            }
          }
          continuation.finish()
        } catch {
          continuation.finish(throwing: error)
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
  @discardableResult func wsOutDefault(
    _ path: RouterPath = "",
    resolve: @escaping @Sendable (WebSocketOutboundWriter) async throws -> Void
  ) -> RouterGroup<BasicWebSocketRequestContext> {
    ws(path) { _, _ in
      .upgrade()
    } onUpgrade: { inbound, outbound, sd in
      await withThrowingTaskGroup { group in
        group.addTask {
          do {
            try await resolve(outbound)
          } catch {
            print("Outbound error: \(error)")
            throw WebSocketError(reason: "Unexpected error while processing output data")
          }
        }

        group.addTask {
          do {
            for try await _ in inbound {
              // Read inbound data to keep the ping-pong connection alive.
            }
          } catch {
            print("Inbound error: \(error)")
            throw WebSocketError(reason: "Unexpected error while processing input data")
          }
        }

        do {
          try await group.waitForAll()
        } catch {
          group.cancelAll()
          let reason = (error as? WebSocketError)?.reason ?? "Unexpected error"
          try? await outbound.close(.unexpectedServerError, reason: reason)
        }
      }
    }
  }

  private struct WebSocketError: Error {
    let reason: String
  }
}
