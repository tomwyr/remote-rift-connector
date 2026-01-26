import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'queue.g.dart';

@JsonSerializable()
class GameQueue extends Equatable {
  GameQueue({
    required this.id,
    required this.name,
    required this.enabled,
    required this.category,
    required this.group,
  });

  final int id;
  final String name;
  final bool enabled;
  final GameQueueCategory category;
  final GameQueueGroup group;

  factory GameQueue.fromJson(Map<String, dynamic> json) => _$GameQueueFromJson(json);

  Map<String, dynamic> toJson() => _$GameQueueToJson(this);

  @override
  List<Object?> get props => [id, name, enabled];
}

enum GameQueueCategory { pvp, ai, other }

enum GameQueueGroup {
  summonersRift,
  aram,
  alternative,
  other;

  int get orderRank => values.indexOf(this) + 1;
}
