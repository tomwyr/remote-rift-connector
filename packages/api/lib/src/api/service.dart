import 'dart:io';

import 'package:shelf/shelf_io.dart';

import 'models.dart';
import 'router.dart';
import 'version.dart';

class RemoteRiftApiService {
  Future<HttpServer> run({required String host, required int port}) async {
    final router = configureRouter();
    final server = await serve(router.call, host, port);
    print('Serving HTTP at http://$host:$port');
    print('WebSocket connections at ws://$host:$port');
    return server;
  }

  Future<RemoteRiftApiServiceInfo> getInfo() async {
    final version = await ApiServiceVersion().load();
    return RemoteRiftApiServiceInfo(version: version);
  }
}
