extends Node
class_name FogPainter

var _map_manager: MapManager
var _map_data: MapData
var _tile_map: TileMap
var _player: Player
var _enemy_container: Node

var _previous_in_sight_cells:Array[Vector2i] = []

func initialize():
  _map_manager = get_tree().current_scene.get_node("%MapManager")
  _map_data = _map_manager.map_data
  _tile_map = get_tree().current_scene.get_node("%TileMap")
  _player = get_tree().current_scene.get_node("%Player")
  _enemy_container = get_tree().current_scene.get_node("%EnemyContainer")
  full_fill_with_unexplored_fog()
  await get_tree().process_frame
  refresh_fog()

func update(_delta):
  refresh_fog()

func full_fill_with_unexplored_fog():
  var allCells:Array[Vector2i] = []
  for x in range(_map_data.max_width):
    for y in range(_map_data.max_height):
      allCells.append(Vector2i(x, y))
  _tile_map.set_cells_terrain_connect(
    MapEnum.TileMapLayer().FOG,
    allCells,
    MapEnum.TerrainSet().FOG,
    MapEnum.FogTerrain().UNEXPLORED,
    false
  )

func refresh_fog():
  var current_in_sight_cells = get_in_sight_cells()
  var fixable_in_sight_cells = get_fixable_in_sight_cells(current_in_sight_cells)
  for cell in fixable_in_sight_cells:
    if current_in_sight_cells.find(cell) < 0:
      current_in_sight_cells.append(cell)
  for cell in current_in_sight_cells:
    if _previous_in_sight_cells.find(cell) >= 0:
      _previous_in_sight_cells.erase(cell)

  _tile_map.set_cells_terrain_connect(
    MapEnum.TileMapLayer().FOG,
    current_in_sight_cells,
    MapEnum.TerrainSet().FOG,
    MapEnum.FogTerrain().IN_SIGHT,
    false
  )
  _tile_map.set_cells_terrain_connect(
    MapEnum.TileMapLayer().FOG,
    _previous_in_sight_cells,
    MapEnum.TerrainSet().FOG,
    MapEnum.FogTerrain().OUT_OF_SIGHT,
    false
  )
  _previous_in_sight_cells = current_in_sight_cells
  refresh_enemy_visibility()

func refresh_enemy_visibility():
  for enemy in _enemy_container.get_children():
    var enemy_cell = enemy.cell
    var enemy_tile_data = _tile_map.get_cell_tile_data(MapEnum.TileMapLayer().FOG, enemy_cell)
    if enemy_tile_data.terrain_set == MapEnum.TerrainSet().FOG && enemy_tile_data.terrain == MapEnum.FogTerrain().IN_SIGHT:
      enemy.visible = true
    else:
      enemy.visible = false

func get_in_sight_cells() -> Array[Vector2i]:
  var in_sight_cells:Array[Vector2i] = []
  var player_sight = _player.character_data.sight
  for y in range(_player.cell.y - player_sight, _player.cell.y + player_sight):
    for x in range(_player.cell.x - player_sight, _player.cell.x + player_sight):
      var cell = Vector2i(x, y)
      var result = _map_manager.cell_intersect_ray(cell, _player.cell, MapEnum.PhysicsLayer().BLOCK_SIGHT, true, [_player.get_node("CharacterBody2D")])
      if result.size() == 0:
        in_sight_cells.append(cell)
  return in_sight_cells

func get_fixable_in_sight_cells(current_in_sight_cells: Array[Vector2i]):
  var fixable_in_sight_cells:Array[Vector2i] = []
  var player_sight = _player.character_data.sight

  for cell in current_in_sight_cells:
    if abs(cell.x - _player.cell.x) < player_sight && abs(cell.y - _player.cell.y) < player_sight:
      var offsets: Array[Vector2i] = []
      if cell.x >= _player.cell.x && cell.y <= _player.cell.y:
        offsets = [Vector2i(1, 0), Vector2i(0, -1), Vector2i(1, -1)]
        var fixable_in_sight_cells_with_offset = get_fixable_in_sight_cells_with_offset(cell, offsets)
        fixable_in_sight_cells.append_array(fixable_in_sight_cells_with_offset)
      if cell.x <= _player.cell.x && cell.y <= _player.cell.y:
        offsets = [Vector2i(-1, 0), Vector2i(0, -1), Vector2i(-1, -1)]
        var fixable_in_sight_cells_with_offset = get_fixable_in_sight_cells_with_offset(cell, offsets)
        fixable_in_sight_cells.append_array(fixable_in_sight_cells_with_offset)
      if cell.x <= _player.cell.x && cell.y >= _player.cell.y:
        offsets = [Vector2i(-1, 0), Vector2i(0, 1), Vector2i(-1, 1)]
        var fixable_in_sight_cells_with_offset = get_fixable_in_sight_cells_with_offset(cell, offsets)
        fixable_in_sight_cells.append_array(fixable_in_sight_cells_with_offset)
      if cell.x >= _player.cell.x && cell.y >= _player.cell.y:
        offsets = [Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]
        var fixable_in_sight_cells_with_offset = get_fixable_in_sight_cells_with_offset(cell, offsets)
        fixable_in_sight_cells.append_array(fixable_in_sight_cells_with_offset)
  return fixable_in_sight_cells
  
func get_fixable_in_sight_cells_with_offset(cell: Vector2i, offset_vectors: Array[Vector2i]):
  var fixable_in_sight_cells:Array[Vector2i] = []
  if !is_cell_block_sight(cell):
    fixable_in_sight_cells.append(cell + offset_vectors[0])
    fixable_in_sight_cells.append(cell + offset_vectors[1])
    fixable_in_sight_cells.append(cell + offset_vectors[2])
  return fixable_in_sight_cells

func is_cell_block_sight(cell: Vector2i) -> bool:
  var result = _map_manager.cell_intersect_point(cell, MapEnum.PhysicsLayer().BLOCK_SIGHT, true, [_player.get_node("CharacterBody2D")])
  return result.size() > 0
