import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handlers.dart';
import 'service.dart';

extension RemoteRiftApiRouter on RemoteRiftApiService {
  Router configureRouter() {
    return Router()
      ..configureStatus()
      ..configureState()
      ..configureLobby()
      ..configureQueue();
  }
}

extension on Router {
  void configureStatus() {
    String route(String value) => '/status/$value';

    mountWs(route('watch'), (webSocket) async {
      await for (var status in RemoteRiftConnector().getStatusStream()) {
        if (webSocket.status == .closed) break;
        webSocket.sink.addJson(status.sealedToJson());
      }
    });
  }

  void configureState() {
    String route(String value) => '/state/$value';

    getJson(route('current'), (request) async {
      final state = await RemoteRiftConnector().getCurrentState();
      return .ok(state.sealedToJson());
    });

    mountWs(route('watch'), (webSocket) async {
      await for (var state in RemoteRiftConnector().getCurrentSateStream()) {
        if (webSocket.status == .closed) break;
        webSocket.sink.addJson(state.sealedToJson());
      }
    });
  }

  void configureLobby() {
    String route(String value) => '/lobby/$value';

    postJson(route('create'), (request) async {
      await RemoteRiftConnector().createLobby();
      return .noContent();
    });

    postJson(route('leave'), (request) async {
      await RemoteRiftConnector().leaveLobby();
      return .noContent();
    });
  }

  void configureQueue() {
    String route(String value) => '/queue/$value';

    postJson(route('start'), (request) async {
      await RemoteRiftConnector().searchMatch();
      return .noContent();
    });

    postJson(route('stop'), (request) async {
      await RemoteRiftConnector().stopMatchSearch();
      return .noContent();
    });

    postJson(route('accept'), (request) async {
      await RemoteRiftConnector().acceptMatch();
      return .noContent();
    });

    postJson(route('decline'), (request) async {
      await RemoteRiftConnector().declineMatch();
      return .noContent();
    });
  }
}
