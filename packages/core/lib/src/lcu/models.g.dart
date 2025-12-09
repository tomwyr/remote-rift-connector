// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
