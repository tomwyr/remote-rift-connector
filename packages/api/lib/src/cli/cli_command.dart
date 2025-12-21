sealed class RemoteRiftCliCommand {}

class Help extends RemoteRiftCliCommand {}

class Run extends RemoteRiftCliCommand {
  Run({required this.host, required this.port});

  final String host;
  final int port;
}

class Invalid extends RemoteRiftCliCommand {}
