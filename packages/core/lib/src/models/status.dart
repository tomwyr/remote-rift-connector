import 'package:json_annotation/json_annotation.dart';

import 'response.dart';

part 'status.g.dart';

@JsonEnum(alwaysCreate: true)
enum RemoteRiftStatus {
  ready,
  unavailable;

  factory RemoteRiftStatus.fromJson(Map<String, dynamic> json) {
    return $enumDecode(_$RemoteRiftStatusEnumMap, json['value']);
  }

  Map<String, dynamic> toJson() {
    return {'value': _$RemoteRiftStatusEnumMap[this]};
  }
}

typedef RemoteRiftStatusResponse = RemoteRiftResponse<RemoteRiftStatus>;
