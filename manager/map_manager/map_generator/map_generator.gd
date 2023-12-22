extends Node
class_name MapGenerator

var bounds_cells: Array[Vector2i] = []

var _rooms = []
var room_cells: Array[Vector2i] = []
var _map_data: DungeonData
var _region_index = 0

var maze_cells: Array[Vector2i] = []

var _tile_set: TileSet
var _tile_map: TileMap
var _map_manager: MapManager


func initialize():
  assert(false, "this method must be overriden")

func update():
  assert(false, "this method must be overriden")

func random_cell_in_rooms():
  assert(false, "this method must be overriden")

func _generate_map():
  assert(false, "this method must be overriden")

func _carve(cells: Array[Vector2i], layer: int, terrain_set: int, terrain: int):
  _tile_map.set_cells_terrain_connect(layer, cells, terrain_set, terrain, false)

func _can_growth(position: Vector2i, direction: Vector2i):
  if bounds_cells.has(position + direction) or bounds_cells.has(position + direction * 2):
    return false
  if room_cells.has(position + direction) or room_cells.has(position + direction * 2):
    return false
  if maze_cells.has(position + direction) or maze_cells.has(position + direction * 2):
    return false
  return true

func _add_bounds():
  for x in range(0, _map_data.max_width):
    bounds_cells.append(Vector2i(x, 0))
    bounds_cells.append(Vector2i(x, _map_data.max_height - 1))
  for y in range(0, _map_data.max_height):
    bounds_cells.append(Vector2i(0, y))
    bounds_cells.append(Vector2i(_map_data.max_width - 1, y))

# Create rooms with the following rules
# 1. Length and width are odd numbers
# 2. The length and width of the room are similar
# 3. rooms do not overlap 
func _add_rooms():
  while _rooms.size() < _map_data.room_count:
    _add_room()

func _add_room():
  var room = _get_random_room()
  if _is_room_intersect_others(room):
    return
  _rooms.append(room)
  for x in range(room.position.x, room.position.x + room.size.x):
    for y in range(room.position.y, room.position.y + room.size.y):
      room_cells.append(Vector2i(x, y))
  _start_region()

func _get_random_room():
  # get random room size
  var base_size = randi_range(1, _map_data.room_base_size_limit) * 2 + 3
  var rectangularity = randi_range(0, 1 + base_size / 2.0)
  var width = base_size
  var height = base_size
  if randf_range(0, 1) > 0.5:
    height = base_size + rectangularity
  else:
    width = base_size + rectangularity

  # get room center
  var room_size = Vector2i(width, height)
  var center = Vector2(randi_range(1, _map_data.max_width - room_size.x - 1), randi_range(1, _map_data.max_height - room_size.y - 1))
  return Rect2i(center, Vector2i(width, height))

func _is_room_intersect_others(room: Rect2) -> bool:
  for other_room in _rooms:
    if (room.intersects(Rect2(other_room.position, other_room.size), true)):
      return true
  return false

func _start_region():
  _region_index += 1

# create maze
func _add_maze():
  var start_cell: Vector2i
  for x in range(1, _map_data.max_width, 2):
    for y in range(1, _map_data.max_height, 2):
      if room_cells.has(Vector2i(x, y)) or maze_cells.has(Vector2i(x, y)) or bounds_cells.has(Vector2i(x, y)):
        continue
      start_cell = Vector2i(x, y)
      break
  _grow_maze(start_cell)

func _grow_maze(start_cell: Vector2i):
  var cells: Array[Vector2i] = []
  var last_direction = Vector2i.ZERO

  _start_region()
  maze_cells.append(start_cell)
  cells.append(start_cell)
  print("start_cell: ", start_cell)
  while cells.size() != 0:
    var cell = cells[cells.size() - 1]
    var unmade_cells: Array[Vector2i] = []
    for direction in [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:
      if _can_growth(cell, direction):
        unmade_cells.append(direction)
    if unmade_cells.size() != 0:
      var dir
      if unmade_cells.has(last_direction) and randi_range(0, 100) > _map_data.winding_percent:
        dir = last_direction
      else:
        dir = unmade_cells[randi_range(0, unmade_cells.size() - 1)]
      maze_cells.append(cell + dir)
      maze_cells.append(cell + dir * 2)
      cells.append(cell + dir * 2)
      print("next cell:", cell + dir * 2)
      last_direction = dir
    else:
      cells.remove_at(cells.size() - 1)
      last_direction = Vector2i.ZERO

# connect rooms and maze
# func connect_regions():
#   var connector_regions: Array[Dictionary] = []
#   for x in range(-1, _map_data.max_width + 1):
#     for y in range(-1, _map_data.max_height + 1):
#       var position = Vector2i(x, y)
#       if room_cells.has(position) or maze_cells.has(position):
#         continue
#       var regions = {}
#       for direction in [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:
#         var region = 

      
#       var region = _get_region(position)
#       if region == 0:
#         continue
#       var connected_region = _get_connected_region(position)
#       if connected_region == 0:
#         continue
#       if connected_regions.has(region):
#         continue
#       _connect_regions(region, connected_region)
#       connected_regions.append(region)
