import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

extension RouterHandlers on Router {
  void getJson(String route, JsonRequestHandler handler) {
    get(route, handler);
  }

  void postJson(String route, JsonRequestHandler handler) {
    post(route, handler);
  }

  void mountWs(String prefix, WebSocketHandler handler) {
    mount(prefix, webSocketHandler((webSocket, _) => handler(webSocket)));
  }
}

extension SinkHandlers on Sink {
  void addJson(Map<String, dynamic> json) {
    add(jsonEncode(json));
  }
}

class JsonResponse extends Response {
  JsonResponse.ok([Map<String, dynamic>? json]) : super.ok(json != null ? jsonEncode(json) : null);
  JsonResponse.noContent() : super(204);
  JsonResponse.badRequest() : super(400);
}

typedef JsonRequestHandler = Future<JsonResponse> Function(Request request);
typedef WebSocketHandler = void Function(WebSocketChannel webSocket);

enum WebSocketStatus { open, closed }

extension WebSocketChannelStatus on WebSocketChannel {
  WebSocketStatus get status => closeCode == null ? .open : .closed;
}

extension RequestParsers on Request {
  int? intQueryParam(String key) {
    if (url.queryParameters[key] case var value?) {
      return int.tryParse(value);
    }
    return null;
  }
}
