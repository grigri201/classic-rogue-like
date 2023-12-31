extends Node2D

var _map_data: MapData
var _astar_grid_manager: AstarGridManager
var _map_manager: MapManager
var _map_generator: MapGenerator

func _ready():
    _map_data = get_tree().current_scene.get_node("%MapManager").map_data
    _astar_grid_manager = get_tree().current_scene.get_node("%AstarGridManager")
    _map_manager = get_tree().current_scene.get_node("%MapManager")
    _map_manager.initialized.connect(_on_map_manager_initialized)

func _on_map_manager_initialized():
  _map_generator = get_tree().current_scene.get_node("%MapManager").map_generator

func _process(_delta):
  queue_redraw()

func _draw():
  if _astar_grid_manager == null or _astar_grid_manager.astar_grid == null:
    return

  # for x in range(_map_data.max_width):
  #   for y in range(_map_data.max_height):
  #     if _astar_grid_manager.astar_grid.is_point_solid(Vector2(x, y)):
  #       draw_circle(_map_manager.cell_id_to_global_position(Vector2(x, y)), 4, Color(1, 0, 0, 0.5)) # red
  if !_map_generator:
    return
  # for cell in _map_generator.junction_cells:
  #   draw_circle(_map_manager.cell_id_to_global_position(cell), 4, Color(1, 0, 0, 0.5)) # red
  # for cell in _map_generator.room_cells:
  #   draw_circle(_map_manager.cell_id_to_global_position(cell), 4, Color(0, 1, 0, 0.5))
  # for cell in _map_generator.maze_cells:
  #   draw_circle(_map_manager.cell_id_to_global_position(cell), 4, Color(0, 0, 1, 0.5)) # blue
