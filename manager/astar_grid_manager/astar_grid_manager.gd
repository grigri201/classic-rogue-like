extends Node
class_name AstarGridManager

var _map_manager: MapManager
var _map_data: MapData
var astar_grid: AStarGrid2D

func initialize():
  _map_manager = get_tree().current_scene.get_node("%MapManager")
  _map_data = _map_manager.map_data

  astar_grid = AStarGrid2D.new()
  astar_grid.region = Rect2(0, 0, _map_data.max_width, _map_data.max_height)
  astar_grid.cell_size = _map_data.cell_size
  astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

  astar_grid.update()

  for i in range(_map_data.max_width):
    for j in range(_map_data.max_height):
      var cell = Vector2i(i, j)
      if is_cell_solid(cell):
        astar_grid.set_point_solid(cell, true)

func is_cell_solid(cell: Vector2i) -> bool:
  var result = _map_manager.cell_intersection_points(
    cell,
    MapEnum.PhysicsLayer().BLOCK_MOVEMENT,
    [get_tree().current_scene.get_node("%Player/CharacterBody2D").get_rid()]
  )
  return result.size() > 0

func update(_delta):
  pass
