extends MapGenerator
class_name DungeonGenerator

func initialize():
  _map_manager = get_parent()
  _map_data = _map_manager.map_data
  _tile_set = load("res://resource/tile_set/grass_land_floor_tile_set.tres")
  _tile_map = get_tree().current_scene.get_node("%TileMap")

  _tile_map.tile_set = _tile_set
  _generate_map()

func update():
  assert(false, "this method must be overriden")

func random_cell_in_rooms():
  return Vector2i(5, 5)
  # while true:
  #   var random_room_index = randi_range(0, _rooms.size() - 1)
  #   var random_room = _rooms[random_room_index]
  #   var random_cell = Vector2i(randi_range(random_room.position.x, random_room.position.x + random_room.size.x - 1), randi_range(random_room.position.y, random_room.position.y + random_room.size.y - 1))
  #   if _map_manager.is_cell_spawnable(random_cell):
  #     return random_cell
  
func _generate_map():
  _add_bounds()
  _carve(bounds_cells, MapEnum.TileMapLayer().FLOOR,  MapEnum.TerrainSet().DEFAULT, MapEnum.Terrain().WALL)
  _add_rooms()
  _carve(room_cells, MapEnum.TileMapLayer().FLOOR,  MapEnum.TerrainSet().DEFAULT, MapEnum.Terrain().FLOOR)
  _add_maze()
  _carve(maze_cells, MapEnum.TileMapLayer().FLOOR,  MapEnum.TerrainSet().DEFAULT, MapEnum.Terrain().FLOOR)

# func _fill_walls():
#   var all_cells: Array[Vector2i] = []
#   for x in range(0, _map_data.map_size.x):
#     for y in range(0, _map_data.map_size.y):
#       all_cells.append(Vector2i(x, y))
#   _tile_map.set_cells_terrain_connect(MapEnum.TileMapLayer().FLOOR, all_cells, MapEnum.TerrainSet().DEFAULT, MapEnum.Terrain().WALL)

# func _random_dig_rooms():
#   var room_cells: Array[Vector2i] = []
#   for i in 5:
#     var room = _get_random_room()
#     if (_is_room_intersect_others(room)):
#       continue
#     _rooms.append(room)
#     for x in range(room.position.x, room.position.x + room.size.x):
#       for y in range(room.position.y, room.position.y + room.size.y):
#         room_cells.append(Vector2i(x, y))
#   if randi_range(0, 1) == 0:
#     _sort_rooms_from_left_to_right()
#   else:
#     _sort_rooms_from_top_to_bottom()
#   _tile_map.set_cells_terrain_connect(MapEnum.TileMapLayer().FLOOR, room_cells, MapEnum.TerrainSet().DEFAULT, MapEnum.Terrain().FLOOR)

# func _get_random_room() -> Rect2i:
#   var room_size = Vector2(randi_range(_map_data.min_room_size.x, _map_data.max_room_size.x), randi_range(_map_data.min_room_size.y, _map_data.max_room_size.y))
#   var room_pos = Vector2(randi_range(1, _map_data.map_size.x - room_size.x - 1), randi_range(1, _map_data.map_size.y - room_size.y - 1))
#   return Rect2i(room_pos, room_size)

# func _is_room_intersect_others(room: Rect2) -> bool:
#   for other_room in _rooms:
#     if (room.intersects(Rect2(other_room.position, other_room.size), true)):
#       return true
#   return false

# func _sort_rooms_from_left_to_right():
#   var _compare_rooms_by_x = func(r1: Rect2i, r2: Rect2i):
#     return r1.position.x <= r2.position.x
#   _rooms.sort_custom(_compare_rooms_by_x)

# func _sort_rooms_from_top_to_bottom():
#   var _compare_rooms_by_y = func(r1: Rect2i, r2: Rect2i):
#     return r1.position.y <= r2.position.y
#   _rooms.sort_custom(_compare_rooms_by_y)

# func _dig_corridors():
#   var corridor_cells: Array[Vector2i] = []
#   for i in range(0, _rooms.size() - 1):
#     var room1 = _rooms[i]
#     var room2 = _rooms[i + 1]
#     var room1_center = room1.get_center()
#     var room2_center = room2.get_center()
#     if randi_range(0, 1) == 0:
#       var horizontal_cells = _get_horizontal_cooridor_cells(room1_center.x, room2_center.x, room1_center.y)
#       var vertical_cells = _get_vertical_cooridor_cells(room1_center.y, room2_center.y, room2_center.x)
#       corridor_cells.append_array(horizontal_cells)
#       corridor_cells.append_array(vertical_cells)
#     else:
#       var vertical_cells = _get_vertical_cooridor_cells(room1_center.y, room2_center.y, room1_center.x)
#       var horizontal_cells = _get_horizontal_cooridor_cells(room1_center.x, room2_center.x, room2_center.y)
#       corridor_cells.append_array(vertical_cells)
#       corridor_cells.append_array(horizontal_cells)
#   _tile_map.set_cells_terrain_connect(MapEnum.TileMapLayer().FLOOR, corridor_cells, MapEnum.TerrainSet().DEFAULT, MapEnum.Terrain().FLOOR)

# func _get_horizontal_cooridor_cells(x1: int, x2: int, y: int) -> Array[Vector2i]:
#   var corridor_cells: Array[Vector2i] = []
#   var step = x2 - x1
#   if step > 0:
#     for x in range(x1, x2 + 1):
#       corridor_cells.append(Vector2i(x, y))
#   else:
#     for x in range(x2, x1 + 1):
#       corridor_cells.append(Vector2i(x, y))
#   return corridor_cells

# func _get_vertical_cooridor_cells(y1: int, y2: int, x: int) -> Array[Vector2i]:
#   var corridor_cells: Array[Vector2i] = []
#   var step = y2 - y1
#   if step > 0:
#     for y in range(y1, y2 + 1):
#       corridor_cells.append(Vector2i(x, y))
#   else:
#     for y in range(y2, y1 + 1):
#       corridor_cells.append(Vector2i(x, y))
#   return corridor_cells
