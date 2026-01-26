import 'package:shelf/shelf.dart';

extension RequestExtensions on Request {
  int? intQueryParam(String key) {
    if (url.queryParameters[key] case var value?) {
      return int.tryParse(value);
    }
    return null;
  }
}
