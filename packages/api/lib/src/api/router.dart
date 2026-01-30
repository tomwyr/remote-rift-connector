import 'package:remote_rift_core/remote_rift_core.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handlers.dart';
import 'service.dart';

extension RemoteRiftApiRouter on RemoteRiftApiService {
  Router configureRouter() {
    return Router()
      ..configureService()
      ..configureStatus()
      ..configureSession()
      ..configureLobby()
      ..configureQueue();
  }
}

extension on Router {
  void configureService() {
    String route(String value) => '/service/$value';

    getJson(route('info'), (request) async {
      final info = await RemoteRiftApiService().getInfo();
      return .ok(info.toJson());
    });
  }

  void configureStatus() {
    String route(String value) => '/status/$value';

    mountWs(route('watch'), (webSocket) async {
      await for (var status in RemoteRiftConnector().getStatusStream()) {
        if (webSocket.status == .closed) break;
        webSocket.sink.addJson(status.sealedToJson());
      }
    });
  }

  void configureSession() {
    String route(String value) => '/session/$value';

    mountWs(route('watch'), (webSocket) async {
      await for (var session in RemoteRiftConnector().getCurrentSessionStream()) {
        if (webSocket.status == .closed) break;
        webSocket.sink.addJson(session.toJson());
      }
    });
  }

  void configureLobby() {
    String route(String value) => '/lobby/$value';

    postJson(route('create'), (request) async {
      final queueId = request.intQueryParam('queueId');
      if (queueId == null) return .badRequest();

      await RemoteRiftConnector().createLobby(queueId: queueId);
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
