// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lobby _$LobbyFromJson(Map<String, dynamic> json) =>
    Lobby(state: $enumDecode(_$GameLobbyStateEnumMap, json['state']));

Map<String, dynamic> _$LobbyToJson(Lobby instance) => <String, dynamic>{
  'state': _$GameLobbyStateEnumMap[instance.state]!,
};

const _$GameLobbyStateEnumMap = {
  GameLobbyState.idle: 'idle',
  GameLobbyState.searching: 'searching',
};

Found _$FoundFromJson(Map<String, dynamic> json) =>
    Found(state: $enumDecode(_$GameFoundStateEnumMap, json['state']));

Map<String, dynamic> _$FoundToJson(Found instance) => <String, dynamic>{
  'state': _$GameFoundStateEnumMap[instance.state]!,
};

const _$GameFoundStateEnumMap = {
  GameFoundState.pending: 'pending',
  GameFoundState.accepted: 'accepted',
  GameFoundState.declined: 'declined',
};

const _$RemoteRiftStatusEnumMap = {
  RemoteRiftStatus.ready: 'ready',
  RemoteRiftStatus.unavailable: 'unavailable',
};

const _$RemoteRiftErrorEnumMap = {
  RemoteRiftError.unableToConnect: 'unableToConnect',
  RemoteRiftError.unknown: 'unknown',
};
