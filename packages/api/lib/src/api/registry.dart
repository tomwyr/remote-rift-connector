import 'dart:async';

import 'package:bonsoir/bonsoir.dart';

class ServiceRegistry {
  ServiceRegistry({required this.serviceName, required this.serviceType});

  factory ServiceRegistry.remoteRift() =>
      ServiceRegistry(serviceName: 'Remote Rift', serviceType: '_remoterift._tcp');

  final String serviceName;
  final String serviceType;

  Future<ServiceBroadcast> broadcast({required int port}) async {
    final broadcast = BonsoirBroadcast(
      service: BonsoirService(
        name: serviceName,
        type: serviceType,
        port: port,
      ),
    );

    try {
      await broadcast.initialize();
      await broadcast.start();
      return ServiceBroadcast(broadcast);
    } catch (error) {
      await broadcast.ensureStopped();
      rethrow;
    }
  }

  Future<ServiceAddress?> discover() async {
    final discovery = BonsoirDiscovery(type: serviceType);

    try {
      await discovery.initialize();

      /// Start listening for the service before running the discovery to avoid
      /// missing the result event while the listener is being set.
      final result = _resolveService(discovery);
      await discovery.start();
      return await result;
    } finally {
      await discovery.ensureStopped();
    }
  }

  Future<ServiceAddress?> _resolveService(BonsoirDiscovery discovery) async {
    final eventStream = discovery.eventStream ?? .empty();
    await for (var event in eventStream) {
      switch (event) {
        case BonsoirDiscoveryServiceFoundEvent():
          event.service.resolve(discovery.serviceResolver);

        case BonsoirDiscoveryServiceResolvedEvent():
          if (event.service case BonsoirService(:var host?, :var port)) {
            return ServiceAddress.normalized(host: host, port: port);
          }

        default:
        // Not interested in other types of events
      }
    }

    return null;
  }
}

class ServiceBroadcast {
  ServiceBroadcast(this._handler);

  final BonsoirBroadcast _handler;

  Future<void> dispose() async {
    await _handler.ensureStopped();
  }
}

class ServiceAddress {
  ServiceAddress({required this.host, required this.port});

  factory ServiceAddress.normalized({required String host, required int port}) {
    // Remove trailing period from host if it's a fully qualified domain name.
    final normalizedHost = host.endsWith('.') ? host.substring(0, host.length - 1) : host;
    return .new(host: normalizedHost, port: port);
  }

  final String host;
  final int port;
}

extension on BonsoirActionHandler {
  Future<void> ensureStopped() async {
    if (!isStopped) {
      await stop();
    }
  }
}
