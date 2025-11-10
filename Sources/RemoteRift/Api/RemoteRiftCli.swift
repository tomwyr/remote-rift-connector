import ArgumentParser

@main
struct RemoteRiftCli: AsyncParsableCommand {
  @Option(help: "The host name or IP address of the API exposed to client applications.")
  var host: String

  @Option(help: "The port number of the API exposed to client applications.")
  var port: Int = 8080

  func run() async throws {
    try await RemoteRiftApi().runService(host: host, port: port)
  }
}
