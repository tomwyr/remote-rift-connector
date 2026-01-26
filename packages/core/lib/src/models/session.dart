import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../converters/state.dart';
import 'state.dart';

part 'session.g.dart';

@JsonSerializable()
class RemoteRiftSession extends Equatable {
  RemoteRiftSession({required this.queueName, required this.state});

  final String? queueName;
  @RemoteRiftStateConverter()
  final RemoteRiftState state;

  factory RemoteRiftSession.fromJson(Map<String, dynamic> json) =>
      _$RemoteRiftSessionFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteRiftSessionToJson(this);

  @override
  List<Object?> get props => [queueName, state];
}
