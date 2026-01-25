// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lcu_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameflowSession _$GameflowSessionFromJson(Map<String, dynamic> json) =>
    GameflowSession(
      gameData: GameflowGameData.fromJson(
        json['gameData'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GameflowSessionToJson(GameflowSession instance) =>
    <String, dynamic>{'gameData': instance.gameData};

GameflowGameData _$GameflowGameDataFromJson(Map<String, dynamic> json) =>
    GameflowGameData(
      queue: GameflowQueue.fromJson(json['queue'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameflowGameDataToJson(GameflowGameData instance) =>
    <String, dynamic>{'queue': instance.queue};

GameflowQueue _$GameflowQueueFromJson(Map<String, dynamic> json) =>
    GameflowQueue(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$GameflowQueueToJson(GameflowQueue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

MatchmakingSearch _$MatchmakingSearchFromJson(Map<String, dynamic> json) =>
    MatchmakingSearch(
      searchState: $enumDecode(
        _$MatchmakingSearchStateEnumMap,
        json['searchState'],
      ),
    );

Map<String, dynamic> _$MatchmakingSearchToJson(MatchmakingSearch instance) =>
    <String, dynamic>{
      'searchState': _$MatchmakingSearchStateEnumMap[instance.searchState]!,
    };

const _$MatchmakingSearchStateEnumMap = {
  MatchmakingSearchState.invalid: 'Invalid',
  MatchmakingSearchState.searching: 'Searching',
  MatchmakingSearchState.found: 'Found',
};

ReadyCheck _$ReadyCheckFromJson(Map<String, dynamic> json) => ReadyCheck(
  state: $enumDecode(_$ReadyCheckStateEnumMap, json['state']),
  timer: (json['timer'] as num).toDouble(),
  playerResponse: $enumDecode(
    _$ReadyCheckResponseEnumMap,
    json['playerResponse'],
  ),
);

Map<String, dynamic> _$ReadyCheckToJson(ReadyCheck instance) =>
    <String, dynamic>{
      'state': _$ReadyCheckStateEnumMap[instance.state]!,
      'timer': instance.timer,
      'playerResponse': _$ReadyCheckResponseEnumMap[instance.playerResponse]!,
    };

const _$ReadyCheckStateEnumMap = {
  ReadyCheckState.invalid: 'Invalid',
  ReadyCheckState.inProgress: 'InProgress',
};

const _$ReadyCheckResponseEnumMap = {
  ReadyCheckResponse.none: 'None',
  ReadyCheckResponse.accepted: 'Accepted',
  ReadyCheckResponse.declined: 'Declined',
};

ReadyCheckError _$ReadyCheckErrorFromJson(Map<String, dynamic> json) =>
    ReadyCheckError(
      httpStatus: (json['httpStatus'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$ReadyCheckErrorToJson(ReadyCheckError instance) =>
    <String, dynamic>{
      'httpStatus': instance.httpStatus,
      'message': instance.message,
    };

HeartbeatConnection _$HeartbeatConnectionFromJson(Map<String, dynamic> json) =>
    HeartbeatConnection(stableConnection: json['stableConnection'] as bool);

Map<String, dynamic> _$HeartbeatConnectionToJson(
  HeartbeatConnection instance,
) => <String, dynamic>{'stableConnection': instance.stableConnection};

const _$GameflowPhaseEnumMap = {
  GameflowPhase.none: 'None',
  GameflowPhase.lobby: 'Lobby',
  GameflowPhase.matchmaking: 'Matchmaking',
  GameflowPhase.readyCheck: 'ReadyCheck',
  GameflowPhase.champSelect: 'ChampSelect',
  GameflowPhase.inProgress: 'InProgress',
  GameflowPhase.waitingForStats: 'WaitingForStats',
  GameflowPhase.preEndOfGame: 'PreEndOfGame',
  GameflowPhase.endOfGame: 'EndOfGame',
};
