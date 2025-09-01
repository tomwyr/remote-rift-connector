import Foundation

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
        print(term)
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
