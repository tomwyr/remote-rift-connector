import 'package:json_annotation/json_annotation.dart';

part 'lcu_models.g.dart';

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.pascal)
enum GameflowPhase {
  none,
  lobby,
  matchmaking,
  readyCheck,
  champSelect,
  inProgress,
  waitingForStats,
  preEndOfGame,
  endOfGame;

  factory GameflowPhase.fromJson(String json) {
    return $enumDecode(_$GameflowPhaseEnumMap, json);
  }
}

@JsonSerializable()
class MatchmakingSearch {
  MatchmakingSearch({required this.searchState});

  final MatchmakingSearchState searchState;

  factory MatchmakingSearch.fromJson(Map<String, dynamic> json) =>
      _$MatchmakingSearchFromJson(json);

  Map<String, dynamic> toJson() => _$MatchmakingSearchToJson(this);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum MatchmakingSearchState { invalid, searching, found }

@JsonSerializable()
class ReadyCheck {
  ReadyCheck({required this.state, required this.timer, required this.playerResponse});

  final ReadyCheckState state;
  final double timer;
  final ReadyCheckResponse playerResponse;

  factory ReadyCheck.fromJson(Map<String, dynamic> json) => _$ReadyCheckFromJson(json);

  Map<String, dynamic> toJson() => _$ReadyCheckToJson(this);
}

@JsonEnum(fieldRename: FieldRename.pascal)
enum ReadyCheckState { invalid, inProgress }

@JsonEnum(fieldRename: FieldRename.pascal)
enum ReadyCheckResponse { none, accepted, declined }

@JsonSerializable()
class ReadyCheckError {
  ReadyCheckError({required this.httpStatus, required this.message});

  final int httpStatus;
  final String message;

  factory ReadyCheckError.fromJson(Map<String, dynamic> json) => _$ReadyCheckErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ReadyCheckErrorToJson(this);
}

@JsonSerializable()
class HeartbeatConnection {
  HeartbeatConnection({required this.stableConnection});

  final bool stableConnection;

  factory HeartbeatConnection.fromJson(Map<String, dynamic> json) =>
      _$HeartbeatConnectionFromJson(json);

  Map<String, dynamic> toJson() => _$HeartbeatConnectionToJson(this);
}
