import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

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

sealed class RemoteRiftState {
  RemoteRiftState();

  factory RemoteRiftState.fromJson(Map<String, dynamic> json) {
    final type = json['value'];
    return switch (type) {
      'preGame' => PreGame(),
      'lobby' => Lobby.fromJson(json),
      'found' => Found.fromJson(json),
      'inGame' => InGame(),
      'unknown' => Unknown(),
      _ => throw ArgumentError('Unexpected RemoteRiftState type $type'),
    };
  }

  Map<String, dynamic> sealedToJson() {
    return switch (this) {
      PreGame() => {'type': 'preGame'},
      Lobby object => {'type': 'lobby', ...object.toJson()},
      Found object => {'type': 'found', ...object.toJson()},
      InGame() => {'type': 'inGame'},
      Unknown() => {'type': 'unknown'},
    };
  }
}

class PreGame extends RemoteRiftState {}

@JsonSerializable()
class Lobby extends RemoteRiftState {
  Lobby({required this.state});

  final GameLobbyState state;

  factory Lobby.fromJson(Map<String, dynamic> json) => _$LobbyFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyToJson(this);
}

@JsonSerializable()
class Found extends RemoteRiftState {
  Found({required this.state});

  final GameFoundState state;

  factory Found.fromJson(Map<String, dynamic> json) => _$FoundFromJson(json);

  Map<String, dynamic> toJson() => _$FoundToJson(this);
}

class InGame extends RemoteRiftState {}

class Unknown extends RemoteRiftState {}

enum GameLobbyState { idle, searching }

enum GameFoundState { pending, accepted, declined }

sealed class RemoteRiftResponse<T> {
  RemoteRiftResponse();

  factory RemoteRiftResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) dataFromJson,
    Map<String, dynamic> Function(T) dataToJson,
  ) {
    final type = json['type'];
    return switch (type) {
      'data' => RemoteRiftData(dataFromJson(json)),
      'error' => RemoteRiftError.fromJson(json),
      _ => throw ArgumentError('Unexpected RemoteRiftResponse type $type'),
    };
  }
}

extension RemoteRiftStatusResponseToJson on RemoteRiftResponse<RemoteRiftStatus> {
  Map<String, dynamic> sealedToJson() {
    return switch (this) {
      RemoteRiftData(value: var data) => {'type': 'data', ...data.toJson()},
      RemoteRiftError error => {'type': 'error', ...error.toJson()},
    };
  }
}

class RemoteRiftData<T> extends RemoteRiftResponse<T> {
  RemoteRiftData(this.value);

  final T value;
}

@JsonEnum(alwaysCreate: true)
enum RemoteRiftError<T extends Never> implements RemoteRiftResponse<T> {
  unableToConnect,
  unknown;

  factory RemoteRiftError.fromJson(Map<String, dynamic> json) {
    return $enumDecode(_$RemoteRiftErrorEnumMap, json['value']);
  }

  Map<String, dynamic> toJson() {
    return {'value': _$RemoteRiftErrorEnumMap[this]};
  }
}
