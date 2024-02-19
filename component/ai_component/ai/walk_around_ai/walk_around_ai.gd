extends AI

signal executed(direction: Vector2i)

var _map_manager: MapManager
var _map_data: MapData
var _astar_grid_manager: AstarGridManager
var _player: Player
var _enemy: Enemy

func initialize():
  _map_manager = get_tree().current_scene.get_node("%MapManager")
  _map_data = _map_manager.map_data
  _astar_grid_manager = get_tree().current_scene.get_node("%AstarGridManager")
  _player = get_tree().current_scene.get_node("%Player")
  _enemy = get_parent().get_parent()

func execute() -> bool:
  var distanceToPlayer = _enemy.get_distance_to(_player.cell)
  if (distanceToPlayer <= _enemy.character_data.sight):
    return false
  _astar_grid_manager.astar_grid.set_point_solid(
    _map_manager.position_to_cell_id(_enemy.global_position),
    false
  )
  var direction: Vector2i
  var movement_horizontal = randi_range(-1, 1)
  # limit movment in 4 direction
  if movement_horizontal != 0:
    direction = Vector2i(movement_horizontal, 0)
  else:
    var movement_vertical = randi_range(-1, 1)
    direction = Vector2i(0, movement_vertical)
  executed.emit(direction)
  return true
