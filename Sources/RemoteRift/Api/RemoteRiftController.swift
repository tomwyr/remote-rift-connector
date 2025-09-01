struct RemoteRiftController {
  func getCurrentState() async throws -> RemoteRiftState {
    let connection = LcuConnection()
    let lockfileData = try connection.getLockfileData()
    let lcuApi = LcuApiClient(httpClient: .noCertificateVerification(), lockfileData: lockfileData)
    let remoteRift = RemoteRift(lcuApi: lcuApi)
    return await remoteRift.getCurrentState()
  }

  func getCurrentSateStream() throws -> AsyncStream<RemoteRiftState> {
    let connection = LcuConnection()
    let lockfileData = try connection.getLockfileData()
    let lcuApi = LcuApiClient(httpClient: .noCertificateVerification(), lockfileData: lockfileData)
    let remoteRift = RemoteRift(lcuApi: lcuApi)
    return remoteRift.getCurrentSateStream()
  }
}
