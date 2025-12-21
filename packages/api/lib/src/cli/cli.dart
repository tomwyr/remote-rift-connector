import 'package:args/args.dart';

import 'cli_command.dart';

class RemoteRiftCli {
  final _argParser = ArgParser()..configureCli();

  RemoteRiftCliCommand tryParse(List<String> arguments) {
    try {
      final results = _argParser.parse(arguments);
      return _parseCommand(results) ?? Invalid();
    } catch (error) {
      return Invalid();
    }
  }

  void printUsage() {
    _argParser.printUsage();
  }

  RemoteRiftCliCommand? _parseCommand(ArgResults results) {
    if (results.flag('help')) {
      return Help();
    }

    final host = results.option('host');
    final portValue = results.option('port');
    final port = portValue != null ? int.parse(portValue) : null;
    if (host != null && port != null) {
      return Run(host: host, port: port);
    }

    return null;
  }
}

extension on ArgParser {
  void configureCli() {
    addFlag('help', negatable: false, help: 'Print this usage information.');
    addOption(
      'host',
      mandatory: true,
      help: 'The host name or IP address of the API exposed to client applications.',
    );
    addOption(
      'port',
      mandatory: false,
      defaultsTo: '8080',
      help: 'The port number of the API exposed to client applications.',
    );
  }

  void printUsage() {
    print('Usage: dart run remote_rift_connector_api <flags> [arguments]');
    print(usage);
  }
}
