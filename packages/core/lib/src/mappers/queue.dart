import '../lcu/lcu_models.dart' as lcu;
import '../models/queue.dart';

class GameQueueMapper {
  static GameQueue fromLcu(lcu.GameQueue queue) {
    return GameQueue(
      id: queue.id,
      name: queue.description,
      enabled: queue.isEnabled,
      category: _mapCategory(queue.gameSelectCategory),
      group: _mapModeGroup(queue.gameSelectModeGroup),
    );
  }

  static GameQueueCategory _mapCategory(String value) {
    return switch (value) {
      lcu.GameSelectCategory.pvp => .pvp,
      lcu.GameSelectCategory.versusAi => .ai,
      _ => .other,
    };
  }

  static GameQueueGroup _mapModeGroup(String value) {
    return switch (value) {
      lcu.GameSelectModeGroup.summonersRift => .summonersRift,
      lcu.GameSelectModeGroup.aram => .aram,
      lcu.GameSelectModeGroup.alternativeLeagueGameModes => .alternative,
      _ => .other,
    };
  }
}

class GameQueueFilter {
  static bool shouldDisplay(lcu.GameQueue queue) {
    if (!queue.isVisible || queue.isCustom) {
      return false;
    }
    if (queue.gameSelectModeGroup == lcu.GameSelectModeGroup.teamfightTactics) {
      return false;
    }
    return true;
  }
}
