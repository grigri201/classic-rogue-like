extends Node2D
class_name Character

@export var character_data: CharacterData
var components: Array[Component] = []
var map_manager: MapManager
var _combat_manager: CombatManager

var is_dead: bool

func initialize():
  map_manager = get_tree().current_scene.get_node("%MapManager")
  _combat_manager = get_tree().current_scene.get_node("%CombatManager")
  var nodes = get_children()
  for node in nodes:
    if node is Component:
      node.initialize()
      components.append(node)
  initialize_combat_attribute()
  _combat_manager.character_dead.connect(_on_character_dead)

func update():
  for component in components:
    component.update()

func initialize_combat_attribute():
  character_data.max_hp = character_data.constitution * character_data.constitution_increament_effects["health"]
  character_data.hp = character_data.max_hp
  character_data.attack = character_data.strength * character_data.strength_increament_effects["attack"]
  character_data.defense = character_data.constitution * character_data.strength_increament_effects["defense"]
  character_data.dodge = character_data.agility * character_data.agility_increament_effects["dodge"]
  character_data.critical = character_data.agility * character_data.agility_increament_effects["critical"]

func get_distance_to(target_cell: Vector2i)->int:
  var start_cell = (Vector2i(global_position) - map_manager.map_data.cell_size / 2) / map_manager.map_data.cell_size
  var distanceX = abs(start_cell.x - target_cell.x)
  var distanceY = abs(start_cell.y - target_cell.y)
  return maxi(distanceX, distanceY)

func _on_character_dead(_character: Character):
  assert(false, "this method must be overriden")
