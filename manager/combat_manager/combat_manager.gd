extends Node
class_name CombatManager

signal character_dead(character: Character)

var _combat_list: Array[Dictionary] = []

func initialize():
  pass

func update():
  _handle_combat_list()

func add_to_combat(attacker: Character, victim: Character):
  var combat = {
    "attacker": attacker,
    "victim": victim
  }
  _combat_list.append(combat)

func _handle_combat_list():
  for combat in _combat_list:
    _handle_combat(combat.attacker, combat.victim)
  _check_deaths()
  _combat_list.clear()

func _handle_combat(attcker: Character, victim: Character):
  if _is_victim_dodge(victim):
    return
  # 2. check if the attacker is critical
  var is_critical = _is_attacker_critical(attcker)
  # 3. calculate the damage
  var damage = _get_damage(attcker, victim, is_critical)
  # 4. decrease the victim's hp
  _handle_victim_damage(victim, damage)

func _is_victim_dodge(victim: Character):
  var randomNumber = randf_range(0, 1)
  if victim.character_data.dodge >= randomNumber:
    return true
  return false

func _is_attacker_critical(attacker: Character):
  var randomNumber = randf_range(0, 1)
  if attacker.character_data.critical >= randomNumber:
    return true
  return false

func _get_damage(attacker: Character, victim: Character, is_critical: bool):
  var damage = attacker.character_data.attack - victim.character_data.defense
  if damage < 0:
    damage = 0
  if is_critical:
    return damage * 2
  return damage

func _handle_victim_damage(victim: Character, damage: int):
  victim.character_data.hp -= damage

func _check_deaths():
  for combat in _combat_list:
    if combat.victim.character_data.hp <= 0:
      combat.victim.character_data.hp = 0
      character_dead.emit(combat.victim)
