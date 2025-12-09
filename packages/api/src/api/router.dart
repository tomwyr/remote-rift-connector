import 'dart:convert';

import 'package:remote_rift_connector_core/remote_rift_connector_core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'api.dart';

extension RemoteRiftApiRouter on RemoteRiftApi {
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

    mountWs(route('watch'), (_, outbound) async {
      await for (var status in RemoteRiftConnector().getStatusStream()) {
        outbound.addJson(status.sealedToJson());
      }
    });
  }

  void configureState() {
    String route(String value) => '/state/$value';

    getJson(route('current'), (request) async {
      final state = await RemoteRiftConnector().getCurrentState();
      return .ok(state.sealedToJson());
    });

    mountWs(route('watch'), (_, outbound) async {
      await for (var state in RemoteRiftConnector().getCurrentSateStream()) {
        outbound.addJson(state.sealedToJson());
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

extension on Router {
  void getJson(String route, RequestHandler handler) {
    get(route, handler);
  }

  void postJson(String route, RequestHandler handler) {
    post(route, handler);
  }

  void mountWs(String prefix, WebSocketHandler handler) {
    mount(prefix, webSocketHandler((webSocket, _) => handler(webSocket.stream, webSocket.sink)));
  }
}

typedef RequestHandler = Future<JsonResponse> Function(Request request);
typedef WebSocketHandler = void Function(Stream inbound, Sink outbound);

class JsonResponse extends Response {
  JsonResponse.ok(Map<String, dynamic> json) : super.ok(jsonEncode(json));
  JsonResponse.noContent() : super(204);
}

extension on Sink {
  void addJson(Map<String, dynamic> json) {
    add(jsonEncode(json));
  }
}
