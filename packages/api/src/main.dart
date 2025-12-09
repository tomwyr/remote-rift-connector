import 'cli/cli.dart';
import 'cli/cli_command.dart';
import 'api/api.dart';

void main(List<String> arguments) async {
  final cli = RemoteRiftCli();

  switch (cli.tryParse(arguments)) {
    case Help() || Invalid():
      cli.printUsage();

    case Run(:var host, :var port):
      RemoteRiftApi().run(host: host, port: port);
  }
}
