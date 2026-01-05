import 'package:shelf/shelf_io.dart';

import 'registry.dart';
import 'router.dart';

class RemoteRiftApi {
  Future<void> run({required String host, required int port}) async {
    final router = configureRouter();
    await serve(router.call, host, port);
    print('Serving HTTP at http://$host:$port');
    print('WebSocket connections at ws://$host:$port');
  }

  Future<ServiceBroadcast> register({required int port}) async {
    final registry = ServiceRegistry.remoteRift();
    final broadcast = await registry.broadcast(port: port);
    print('mDNS service advertised: _remoterift._tcp on port $port');
    return broadcast;
  }

  Future<ServiceAddress?> findAddress() async {
    final registry = ServiceRegistry.remoteRift();
    return await registry.discover();
  }
}
