import 'dart:io';

import 'config_error.dart';
import 'config_source.dart';

class RemoteRiftApiConfig {
  RemoteRiftApiConfig({required this.host, required this.port});

  final String host;
  final int port;

  static const envHostKey = 'API_HOST';
  static const envPortKey = 'API_PORT';
  static const defaultPort = 8080;

  static Future<RemoteRiftApiConfig> resolve({required RemoteRiftApiConfigSource source}) async {
    return switch (source) {
      EnvironmentSource() => _readFromEnvironment(),
      SystemLookupSource(:var resolveAddress) => await _lookupDeviceNetworks(resolveAddress),
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

  static Future<RemoteRiftApiConfig> _lookupDeviceNetworks(
    SystemLookupAddressResolver? resolver,
  ) async {
    final addresses = <String>[];
    for (var interface in await NetworkInterface.list()) {
      for (var address in interface.addresses) {
        if (address.type == .IPv4 && !address.isLoopback) {
          addresses.add(address.address);
        }
      }
    }

    if (addresses.isEmpty) {
      throw AddressNotFound();
    }
    if (addresses.length > 1 && resolver == null) {
      throw MultipleAddressesFound();
    }

    String host;
    if (addresses.length > 1 && resolver != null) {
      host = resolver(addresses);
    } else {
      host = addresses.first;
    }

    return .new(host: host, port: defaultPort);
  }
}
