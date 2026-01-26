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
class GameflowSession {
  GameflowSession({required this.gameData});

  final GameflowGameData gameData;

  factory GameflowSession.fromJson(Map<String, dynamic> json) => _$GameflowSessionFromJson(json);

  Map<String, dynamic> toJson() => _$GameflowSessionToJson(this);
}

@JsonSerializable()
class GameflowGameData {
  GameflowGameData({required this.queue});

  final GameflowQueue queue;

  factory GameflowGameData.fromJson(Map<String, dynamic> json) => _$GameflowGameDataFromJson(json);

  Map<String, dynamic> toJson() => _$GameflowGameDataToJson(this);
}

@JsonSerializable()
class GameflowQueue {
  GameflowQueue({required this.id, required this.name, required this.description});

  final int id;
  final String name;
  final String description;

  factory GameflowQueue.fromJson(Map<String, dynamic> json) => _$GameflowQueueFromJson(json);

  Map<String, dynamic> toJson() => _$GameflowQueueToJson(this);
}

@JsonSerializable()
class GameQueue {
  GameQueue({
    required this.id,
    required this.name,
    required this.description,
    required this.gameMode,
    required this.gameSelectCategory,
    required this.gameSelectModeGroup,
    required this.isEnabled,
    required this.isVisible,
    required this.isCustom,
  });

  final int id;
  final String name;
  final String description;
  final String gameMode;
  final String gameSelectCategory;
  final String gameSelectModeGroup;
  final bool isEnabled;
  final bool isVisible;
  final bool isCustom;

  factory GameQueue.fromJson(Map<String, dynamic> json) => _$GameQueueFromJson(json);

  Map<String, dynamic> toJson() => _$GameQueueToJson(this);
}

class GameSelectCategory {
  static const pvp = 'kPvP';
  static const versusAi = 'kVersusAI';
}

class GameSelectModeGroup {
  static const summonersRift = 'kSummonersRift';
  static const aram = 'kARAM';
  static const alternativeLeagueGameModes = 'kAlternativeLeagueGameModes';
  static const teamfightTactics = 'kTeamfightTactics';
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
class ReadyCheckError implements Exception {
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
