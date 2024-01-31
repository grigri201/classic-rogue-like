extends Node2D
class_name Character

@export var character_data: CharacterData
var components: Array[Component] = []
var map_manager: MapManager
var _combat_manager: CombatManager

var is_dead: bool
var cell: Vector2i

func initialize():
  map_manager = get_tree().current_scene.get_node("%MapManager")
  _combat_manager = get_tree().current_scene.get_node("%CombatManager")
  var nodes = get_children()
  for node in nodes:
    if node is Component:
      node.initialize()
      components.append(node)
  _combat_manager.character_dead.connect(_on_character_dead)

func update(_delta):
  for component in components:
    component.update(_delta)

func get_distance_to(target_cell: Vector2i)->int:
  var distanceX = abs(cell.x - target_cell.x)
  var distanceY = abs(cell.y - target_cell.y)
  return maxi(distanceX, distanceY)

func _on_character_dead(_character: Character):
  assert(false, "this method must be overriden")
