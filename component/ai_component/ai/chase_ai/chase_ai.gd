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
  var distanceToPlayer = _enemy.get_distance_to(_player.cell)
  if (distanceToPlayer > _enemy.character_data.sight or distanceToPlayer <= 1):
    return false
  var path_cells = _astar_grid_manager.astar_grid.get_id_path(_enemy.cell, _player.cell)
  if path_cells.size() < 1:
    return false
  var direction = path_cells[1] - _enemy.cell
  executed.emit(direction)
  return true
