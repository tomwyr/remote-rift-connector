import 'package:json_annotation/json_annotation.dart';

import '../models/state.dart';

class RemoteRiftStateConverter extends JsonConverter<RemoteRiftState, Map<String, dynamic>> {
  const RemoteRiftStateConverter();

  @override
  RemoteRiftState fromJson(Map<String, dynamic> json) {
    return RemoteRiftState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(RemoteRiftState object) {
    return object.sealedToJson();
  }
}
