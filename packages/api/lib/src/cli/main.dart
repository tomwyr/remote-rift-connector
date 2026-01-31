import '../api/config/config.dart';
import '../api/service.dart';
import 'cli.dart';
import 'cli_command.dart';

void main(List<String> arguments) async {
  final cli = RemoteRiftCli();

  switch (cli.tryParse(arguments)) {
    case Help() || Invalid():
      cli.printUsage();

    case Run(:var host, :var port):
      RemoteRiftApiService().run(host: host, port: port);

    case RunWithAddressLookup():
      final RemoteRiftApiConfig(:host, :port) = await .resolve(source: .systemLookup());
      RemoteRiftApiService().run(host: host, port: port);
  }
}
