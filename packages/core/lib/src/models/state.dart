import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'state.g.dart';

sealed class RemoteRiftState extends Equatable {
  const RemoteRiftState();

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
      PreGame() => {'value': 'preGame'},
      Lobby object => {'value': 'lobby', ...object.toJson()},
      Found object => {'value': 'found', ...object.toJson()},
      InGame() => {'value': 'inGame'},
      Unknown() => {'value': 'unknown'},
    };
  }

  @override
  List<Object?> get props => [];
}

class PreGame extends RemoteRiftState {}

@JsonSerializable()
class Lobby extends RemoteRiftState {
  const Lobby({required this.state});

  final GameLobbyState state;

  factory Lobby.fromJson(Map<String, dynamic> json) => _$LobbyFromJson(json);

  Map<String, dynamic> toJson() => _$LobbyToJson(this);

  @override
  List<Object?> get props => [state];
}

@JsonSerializable()
class Found extends RemoteRiftState {
  const Found({required this.state, required this.answerMaxTime, required this.answerTimeLeft});

  final GameFoundState state;
  final double answerMaxTime;
  final double answerTimeLeft;

  factory Found.fromJson(Map<String, dynamic> json) => _$FoundFromJson(json);

  Map<String, dynamic> toJson() => _$FoundToJson(this);

  @override
  List<Object?> get props => [state];
}

class InGame extends RemoteRiftState {}

class Unknown extends RemoteRiftState {}

enum GameLobbyState { idle, searching }

enum GameFoundState { pending, accepted, declined }
