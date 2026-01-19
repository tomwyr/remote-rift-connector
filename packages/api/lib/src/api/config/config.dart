import 'dart:io';

import 'config_error.dart';

enum RemoteRiftApiConfigSource { environment, systemLookup }

class RemoteRiftApiConfig {
  RemoteRiftApiConfig({required this.host, required this.port});

  final String host;
  final int port;

  static const envHostKey = 'API_HOST';
  static const envPortKey = 'API_PORT';
  static const defaultPort = 8080;

  static Future<RemoteRiftApiConfig> resolve({required RemoteRiftApiConfigSource source}) async {
    return switch (source) {
      .environment => _readFromEnvironment(),
      .systemLookup => await _lookupDeviceNetworks(),
    };
  }

  static RemoteRiftApiConfig _readFromEnvironment() {
    const host = String.fromEnvironment(envHostKey);
    if (host.isEmpty) {
      throw AddressHostMissing();
    }

    const portStr = String.fromEnvironment(envPortKey);
    if (portStr.isEmpty) {
      throw AddressPortMissing();
    }
    final port = int.tryParse(portStr);
    if (port == null) {
      throw AddressPortInvalid(input: portStr);
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
      throw AddressNotFound();
    }
    if (addresses.length > 1) {
      throw MultipleAddressesFound();
    }

    return .new(host: addresses.single.address, port: defaultPort);
  }
}
