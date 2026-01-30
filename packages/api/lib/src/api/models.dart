import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class RemoteRiftApiServiceInfo {
  RemoteRiftApiServiceInfo({required this.version});

  final String version;

  factory RemoteRiftApiServiceInfo.fromJson(Map<String, dynamic> json) =>
      _$RemoteRiftApiServiceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteRiftApiServiceInfoToJson(this);
}
