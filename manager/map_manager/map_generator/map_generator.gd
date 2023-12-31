extends Node
class_name MapGenerator

var _rooms = []
var room_cells: Array[Vector2i] = []
var connector_cells: Array[Vector2i] = []
var _map_data: DungeonData
var _region_index = 0
var _regions: Dictionary = {}

var _tile_set: TileSet
var _tile_map: TileMap
var _map_manager: MapManager

func initialize():
  assert(false, "this method must be overriden")

func update(_delta):
  assert(false, "this method must be overriden")

func _generate_map():
  assert(false, "this method must be overriden")

func _carve(cells: Array[Vector2i], layer: int, terrain_set: int, terrain: int):
  _tile_map.set_cells_terrain_connect(layer, cells, terrain_set, terrain, false)

func _is_room_intersect_others(room: Rect2) -> bool:
  if room.position.x < 0 or room.position.y < 0 or room.position.x + room.size.x >= _map_data.max_width or room.position.y + room.size.y >= _map_data.max_height:
    return true
  for other_room in _rooms:
    if room.intersects(Rect2(other_room.position, other_room.size), true):
      return true
  return false

func _in_bounds(position: Vector2i):
  return position.x >= 0 and position.x < _map_data.max_width and position.y >= 0 and position.y < _map_data.max_height

func _get_random_item(items: Array):
  var random_index = randi_range(0, items.size() - 1)
  return items[random_index]

func _get_position_with_center(center: Vector2i, size: Vector2i):
  var position = center - size / 2
  return position

func fill_walls():
  # wrap the map with walls at -1 and max + 1
  var area: Rect2i = Rect2i(Vector2i.ZERO, Vector2i(_map_data.max_width, _map_data.max_height)).grow(1)
  var bounds_cells: Array[Vector2i] = []
  for x in range(area.position.x, area.end.x + 1):
    for y in range(area.position.y, area.end.y + 1):
      var cell = Vector2i(x, y)
      bounds_cells.append(cell)
  _carve(bounds_cells, MapEnum.TileMapLayer().FLOOR,  MapEnum.TerrainSet().DEFAULT, MapEnum.Terrain().WALL)

func add_rooms():
  var retry_count = 0
  while _rooms.size() < _map_data.room_count:
    if retry_count > 100:
      break
    var room_size = _get_random_room_size()
    var room: Rect2i
    if _rooms.size() > 0:
      for i in range(_rooms.size() - 1, -1, -1):
        var last_room = _rooms[i]
        room = _get_valid_room_rect(last_room, room_size)
        if room.size != Vector2i.ZERO:
          add_connectors(last_room, room)
          break
    else:
      var random_center = Vector2i(randi_range(room_size.x / 2, _map_data.max_width - room_size.x / 2), randi_range(room_size.y / 2, _map_data.max_height - room_size.y / 2))
      room = Rect2i(_get_position_with_center(random_center, room_size), room_size)
    if room.size == Vector2i.ZERO:
      retry_count += 1
    else:
      retry_count = 0
      _add_room(room)

func _add_room(room: Rect2i):
  if room.size == Vector2i.ZERO:
    return
  _rooms.append(room)
  for x in range(room.position.x, room.end.x):
    for y in range(room.position.y, room.end.y):
      var cell = Vector2i(x, y)
      room_cells.append(cell)

func _get_valid_room_rect(last_room: Rect2i, room_size: Vector2i) -> Rect2i:
  var directions = [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
  for i in range(0, directions.size()):
    var random_index = randi_range(0, directions.size() - 1)
    var dir = directions[random_index]
    directions.remove_at(random_index)
    var center = last_room.get_center() + dir * last_room.size + dir * 2
    var new_room = Rect2i(_get_position_with_center(center, room_size), room_size)
    if !_is_room_intersect_others(new_room):
      return new_room
  return Rect2i(Vector2i.ZERO, Vector2i.ZERO)

func _get_random_room_size():
  # get random room size
  # ensure that size and position are both odd numbers
  var base_size = randi_range(1, _map_data.room_base_size_limit) * 2 + 2
  var rectangularity = randi_range(0, base_size / 2.0) * 2
  var width = base_size
  var height = base_size
  if randf_range(0, 1) > 0.5:
    height = base_size + rectangularity
  else:
    width = base_size + rectangularity
  return Vector2i(width, height)

func add_connectors(last_room: Rect2i, room: Rect2i):
  var connector_width = randi_range(_map_data.connector_width_limit[0], _map_data.connector_width_limit[1] + 1)
  var last_room_center = last_room.get_center()
  var room_center = room.get_center()
  
  var connector_position = Vector2i(min(last_room_center.x, room_center.x), min(last_room_center.y, room_center.y))
  var connector_size = Vector2i(abs(last_room_center.x - room_center.x), abs(last_room_center.y - room_center.y))
  
  if connector_size.x == 0:
    connector_position.y -= connector_width / 2.0
    connector_size.x = connector_width
  if connector_size.y == 0:
    connector_position.x -= connector_width / 2.0
    connector_size.y = connector_width
  
  var connector = Rect2i(connector_position, connector_size)

  # add connectors cells to connector_cells
  for x in range(connector.position.x, connector.end.x + 1):
    for y in range(connector.position.y, connector.end.y + 1):
      var cell = Vector2i(x, y)
      if room_cells.has(cell) or connector_cells.has(cell):
        continue
      connector_cells.append(cell)

# Create rooms with the following rules
# 1. create a random room with random position at odd position
# 2. the length and width of the room are similar
# 3. rooms do not overlap 
# 4. get random room size
# 5. find a random position from last room to create a new room
# 6. add connectors between rooms with random width

func random_cell_in_rooms():
  # return Vector2i(1, 1)
  while true:
    var random_room_index = randi_range(0, _rooms.size() - 1)
    var random_room = _rooms[random_room_index]
    var random_cell = Vector2i(randi_range(random_room.position.x, random_room.position.x + random_room.size.x - 1), randi_range(random_room.position.y, random_room.position.y + random_room.size.y - 1))
    if _map_manager.is_cell_spawnable(random_cell):
      _map_manager.allocate_spawn_cell(random_cell)
      return random_cell
