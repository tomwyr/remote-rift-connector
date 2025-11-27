import Foundation
import Hummingbird
import HummingbirdWebSocket
import Logging

extension Router where Context == BasicWebSocketRequestContext {
  static func webSocketSupported() -> Router {
    .init(context: BasicWebSocketRequestContext.self)
  }

  func configure() -> Self {
    configureStatus()
    configureState()
    configureLobby()
    configureQueue()
    return self
  }

  private func configureStatus() {
    let status = group("status")

    status.wsOutSafe("watch") { outbound in
      for await state in RemoteRiftConnector().getStatusStream() {
        let json = try state.jsonEncoded()
        try await outbound.write(.text(json))
      }
    }
  }

  private func configureState() {
    let state = group("state")

    state.get("current") { req, res async throws in
      try await RemoteRiftConnector().getCurrentState()
    }

    state.wsOutSafe("watch") { outbound in
      for await state in RemoteRiftConnector().getCurrentSateStream() {
        let json = try state.jsonEncoded()
        try await outbound.write(.text(json))
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
