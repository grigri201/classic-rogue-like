extends AI

signal executed(direction: Vector2i)

var _map_manager: MapManager
var _map_data: MapData
var _astar_grid_manager: AstarGridManager
var _player: Player
var _enemy: Enemy

func initialize():
  _map_manager= get_tree().current_scene.get_node("%MapManager")
  _map_data = _map_manager.map_data
  _astar_grid_manager = get_tree().current_scene.get_node("%AstarGridManager")
  _player = get_tree().current_scene.get_node("%Player")
  _enemy = get_parent().get_parent()

func execute() -> bool:
  var distanceToPlayer = _enemy.get_distance_to((Vector2i(_player.global_position) - _map_data.cell_size / 2) / _map_data.cell_size)
  if (distanceToPlayer > _enemy.character_data.slight or distanceToPlayer <= 1):
    return false
  var enemy_cell = (Vector2i(_enemy.global_position) - _map_data.cell_size / 2) / _map_data.cell_size
  var player_cell = (Vector2i(_player.global_position) - _map_data.cell_size / 2) / _map_data.cell_size
  _astar_grid_manager.astar_grid.set_point_solid(
    _map_manager.position_to_cell_id(_enemy.global_position),
    false
  )
  var path_cells = _astar_grid_manager.astar_grid.get_id_path(enemy_cell, player_cell)
  if path_cells.size() < 2:
    return false
  var direction = path_cells[1] - enemy_cell
  executed.emit(direction)
  return true
