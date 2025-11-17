import Foundation
import Hummingbird
import HummingbirdWebSocket
import Logging

extension Router where Context == BasicWebSocketRequestContext {
  static func webSocketSupported() -> Router {
    .init(context: BasicWebSocketRequestContext.self)
  }

  func configure() -> Self {
    configureState()
    configureLobby()
    configureQueue()
    return self
  }

  private func configureState() {
    let state = group("state")

    state.get("current") { req, res async throws in
      let state = try await RemoteRiftConnector().getCurrentState()
      return JsonResponseGenerator(value: state)
    }

    state.ws("watch") { _, _ in
      .upgrade()
    } onUpgrade: { inbound, outbound, sd in
      func streamCurrentState() async throws {
        for await state in RemoteRiftConnector().getCurrentSateStream() {
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
  }

  private func configureLobby() {
    let lobby = group("lobby")

    lobby.post("create") { req, res async throws in
      try await RemoteRiftConnector().createLobby()
      return HTTPResponse.Status.noContent
    }

    lobby.post("leave") { req, res async throws in
      try await RemoteRiftConnector().leaveLobby()
      return HTTPResponse.Status.noContent
    }
  }

  private func configureQueue() {
    let queue = group("queue")

    queue.post("start") { req, res async throws in
      try await RemoteRiftConnector().searchMatch()
      return HTTPResponse.Status.noContent
    }

    queue.post("stop") { req, res async throws in
      try await RemoteRiftConnector().stopMatchSearch()
      return HTTPResponse.Status.noContent
    }

    queue.post("accept") { req, res async throws in
      try await RemoteRiftConnector().acceptMatch()
      return HTTPResponse.Status.noContent
    }

    queue.post("decline") { req, res async throws in
      try await RemoteRiftConnector().declineMatch()
      return HTTPResponse.Status.noContent
    }
  }
}

extension RemoteRiftConnector {
  init() {
    let lcuApi = LcuApiClient(
      httpClient: .noCertificateVerification(),
      lcuConnection: LcuConnection(),
    )
    self.init(lcuApi: lcuApi)
  }
}
