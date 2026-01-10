import 'package:shelf/shelf_io.dart';

import 'router.dart';

class RemoteRiftApiService {
  Future<void> run({required String host, required int port}) async {
    final router = configureRouter();
    await serve(router.call, host, port);
    print('Serving HTTP at http://$host:$port');
    print('WebSocket connections at ws://$host:$port');
  }
}
