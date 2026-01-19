import 'dart:io';

enum RemoteRiftApiConfigSource { environment, systemLookup }

class RemoteRiftApiConfig {
  RemoteRiftApiConfig({required this.host, required this.port});

  final String host;
  final int port;

  static const _defaultPort = 8080;

  static Future<RemoteRiftApiConfig> resolve({required RemoteRiftApiConfigSource source}) async {
    return switch (source) {
      .environment => _readFromEnvironment(),
      .systemLookup => await _lookupDeviceNetworks(),
    };
  }

  static RemoteRiftApiConfig _readFromEnvironment() {
    const hostKey = 'API_HOST';
    const host = String.fromEnvironment(hostKey);
    if (host.isEmpty) {
      throw StateError('$hostKey must be provided');
    }

    const portKey = 'API_PORT';
    const portStr = String.fromEnvironment(portKey);
    if (portStr.isEmpty) {
      throw StateError('$portKey must be provided');
    }
    final port = int.tryParse(portStr);
    if (port == null) {
      throw StateError('Invalid $portKey: "$portStr"');
    }

    return .new(host: host, port: port);
  }

  static Future<RemoteRiftApiConfig> _lookupDeviceNetworks() async {
    final addresses = <InternetAddress>[];
    for (var interface in await NetworkInterface.list()) {
      for (var address in interface.addresses) {
        if (address.type == .IPv4 && !address.isLoopback) {
          addresses.add(address);
        }
      }
    }

    if (addresses.isEmpty) {
      throw StateError('No IPv4 network is connected');
    }
    if (addresses.length > 1) {
      throw StateError('Multiple IPv4 networks are connected');
    }

    return .new(host: addresses.single.address, port: _defaultPort);
  }
}
