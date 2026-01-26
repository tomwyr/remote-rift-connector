// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreGame _$PreGameFromJson(Map<String, dynamic> json) => PreGame(
  availableQueues: (json['availableQueues'] as List<dynamic>)
      .map((e) => GameQueue.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PreGameToJson(PreGame instance) => <String, dynamic>{
  'availableQueues': instance.availableQueues,
};

Lobby _$LobbyFromJson(Map<String, dynamic> json) =>
    Lobby(state: $enumDecode(_$GameLobbyStateEnumMap, json['state']));

Map<String, dynamic> _$LobbyToJson(Lobby instance) => <String, dynamic>{
  'state': _$GameLobbyStateEnumMap[instance.state]!,
};

const _$GameLobbyStateEnumMap = {
  GameLobbyState.idle: 'idle',
  GameLobbyState.searching: 'searching',
};

Found _$FoundFromJson(Map<String, dynamic> json) => Found(
  state: $enumDecode(_$GameFoundStateEnumMap, json['state']),
  answerMaxTime: (json['answerMaxTime'] as num).toDouble(),
  answerTimeLeft: (json['answerTimeLeft'] as num).toDouble(),
);

Map<String, dynamic> _$FoundToJson(Found instance) => <String, dynamic>{
  'state': _$GameFoundStateEnumMap[instance.state]!,
  'answerMaxTime': instance.answerMaxTime,
  'answerTimeLeft': instance.answerTimeLeft,
};

const _$GameFoundStateEnumMap = {
  GameFoundState.pending: 'pending',
  GameFoundState.accepted: 'accepted',
  GameFoundState.declined: 'declined',
};
