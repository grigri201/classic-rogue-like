extends MapGenerator
class_name DungeonGenerator

func initialize():
  _map_manager = get_parent()
  _map_data = _map_manager.map_data
  _tile_set = load("res://resource/tile_set/fantasy_tile_set.tres")
  _tile_map = get_tree().current_scene.get_node("%TileMap")

  _tile_map.tile_set = _tile_set
  _generate_map()

func update(_delta):
  assert(false, "this method must be overriden")
  
func _generate_map():
  fill_walls()
  add_rooms()
  _carve(room_cells, MapEnum.TileMapLayer().FLOOR,  MapEnum.TerrainSet().DEFAULT, MapEnum.Terrain().FLOOR)
  _carve(connector_cells, MapEnum.TileMapLayer().FLOOR,  MapEnum.TerrainSet().DEFAULT, MapEnum.Terrain().FLOOR)
  