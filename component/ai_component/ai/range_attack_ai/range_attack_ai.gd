extends AI

var _map_data: MapData
var _player: Player
var _enemy: Enemy
var _combat_manager: CombatManager

var _line: Line2D

func initialize():
  _map_data = get_tree().current_scene.get_node("%MapManager").map_data
  _player = get_tree().current_scene.get_node("%Player")
  _enemy = get_parent().get_parent()
  _combat_manager = get_tree().current_scene.get_node("%CombatManager")
  _line = get_node("Line2D")

func execute() -> bool:
  var distanceToPlayer = _enemy.get_distance_to((Vector2i(_player.global_position) - _map_data.cell_size / 2) / _map_data.cell_size)
  if distanceToPlayer > _enemy.character_data.slight:
    return false
  _combat_manager.add_to_combat(_enemy, _player)
  show_range_attack_line(_enemy.global_position, _player.global_position)
  return true

func show_range_attack_line(start: Vector2, end: Vector2):
  _line.set_point_position(0, start)
  _line.set_point_position(1, end)
  await get_tree().process_frame
  _line.set_point_position(0, Vector2.ZERO)
  _line.set_point_position(1, Vector2.ZERO)
