extends AI

signal executed(direction: Vector2i)

var _map_manager: MapManager
var _map_data: MapData
var _astar_grid_manager: AstarGridManager
var _player: Player
var _enemy: Enemy

var directions: Array = [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
var current_direction_index: int = 0

func initialize():
  _map_manager = get_tree().current_scene.get_node("%MapManager")
  _map_data = _map_manager.map_data
  _astar_grid_manager = get_tree().current_scene.get_node("%AstarGridManager")
  _player = get_tree().current_scene.get_node("%Player")
  _enemy = get_parent().get_parent()
  _check_area()

func _check_area():
  var position = Vector2i(_enemy.global_position)
  while current_direction_index <= directions.size():
    for i in range(directions.size()):
      var index = (i + current_direction_index) % directions.size()
      var target_position = position + directions[index] * _map_data.cell_size
      var result = _map_manager.intersection_points(target_position, MapEnum.PhysicsLayer().BLOCK_MOVEMENT, [_enemy.get_node("CharacterBody2D")])
      if result.size() > 0:
        break
    current_direction_index += 1

func execute() -> bool:
  var distanceToPlayer = _enemy.get_distance_to((Vector2i(_player.global_position) - _map_data.cell_size / 2) / _map_data.cell_size)
  if (distanceToPlayer <= _enemy.character_data.sight):
    return false
  _astar_grid_manager.astar_grid.set_point_solid(
    _map_manager.position_to_cell_id(_enemy.global_position),
    false
  )
  var direction: Vector2i = Vector2i.ZERO
  # TODO:  add moving_chance to enemy
  var move_chance = 0.2
  var will_move = randf_range(0, 1)
  if will_move > move_chance:
    current_direction_index = current_direction_index % directions.size()
    direction = directions[current_direction_index]
    current_direction_index += 1
  executed.emit(direction)
  return true
