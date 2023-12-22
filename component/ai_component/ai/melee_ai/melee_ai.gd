extends AI

var _map_data: MapData
var _player: Player
var _enemy: Enemy
var _combat_manager: CombatManager

func initialize():
  _map_data = get_tree().current_scene.get_node("%MapManager").map_data
  _player = get_tree().current_scene.get_node("%Player")
  _enemy = get_parent().get_parent()
  _combat_manager = get_tree().current_scene.get_node("%CombatManager")

func execute() -> bool:
  var distanceToPlayer = _enemy.get_distance_to((Vector2i(_player.global_position) - _map_data.cell_size / 2) / _map_data.cell_size)
  if distanceToPlayer > 1:
    return false
  _combat_manager.add_to_combat(_enemy, _player)
  return true
