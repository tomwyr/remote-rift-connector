// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameQueue _$GameQueueFromJson(Map<String, dynamic> json) => GameQueue(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  enabled: json['enabled'] as bool,
  category: $enumDecode(_$GameQueueCategoryEnumMap, json['category']),
  group: $enumDecode(_$GameQueueGroupEnumMap, json['group']),
);

Map<String, dynamic> _$GameQueueToJson(GameQueue instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'enabled': instance.enabled,
  'category': _$GameQueueCategoryEnumMap[instance.category]!,
  'group': _$GameQueueGroupEnumMap[instance.group]!,
};

const _$GameQueueCategoryEnumMap = {
  GameQueueCategory.pvp: 'pvp',
  GameQueueCategory.ai: 'ai',
  GameQueueCategory.other: 'other',
};

const _$GameQueueGroupEnumMap = {
  GameQueueGroup.summonersRift: 'summonersRift',
  GameQueueGroup.aram: 'aram',
  GameQueueGroup.alternative: 'alternative',
  GameQueueGroup.other: 'other',
};
