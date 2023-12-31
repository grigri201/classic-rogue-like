extends AI
class_name SkillAI

signal skill_used

var _skill_cooldown = -1
var count

func initialize():
  _skill_cooldown = owner.character_data.skill_cooldown
  count = 0

func execute() -> bool:
  if count < _skill_cooldown:
    count += 1
    return false
  skill_used.emit()
  count = 0
  return true
