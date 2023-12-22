extends Node2D
class_name PickableObject

var _map_data: MapData;
var _tile_map: TileMap;
var _player: Player;

@export var object_name: String;
@export var description: String;

func initialize():
  _map_data = get_tree().current_scene.get_node("%MapManager").map_data
  _tile_map = get_tree().current_scene.get_node("%TileMap")
  _player = get_tree().current_scene.get_node("%Player")

func update():
  assert(false, "this method must be overriden")
