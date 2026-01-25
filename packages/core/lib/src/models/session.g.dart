// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteRiftSession _$RemoteRiftSessionFromJson(Map<String, dynamic> json) =>
    RemoteRiftSession(
      queueName: json['queueName'] as String?,
      state: const RemoteRiftStateConverter().fromJson(
        json['state'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$RemoteRiftSessionToJson(RemoteRiftSession instance) =>
    <String, dynamic>{
      'queueName': instance.queueName,
      'state': const RemoteRiftStateConverter().toJson(instance.state),
    };
