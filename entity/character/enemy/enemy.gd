extends Character
class_name Enemy

@export var id: String

var _late_update_components: Array[LateUpdateComponent] = []
var _astar_grid_manager: AstarGridManager
var _sprite: Sprite2D

var _skill_ai: SkillAI

func initialize():
  _sprite = get_node("Sprite")
  _init_enemy()
  super.initialize()
  _skill_ai = get_node("AiComponent/SkillAi")
  _astar_grid_manager = get_tree().current_scene.get_node("%AstarGridManager")


  map_manager.initialized.connect(_on_map_initialized)
  var nodes = get_children()
  for node in nodes:
    if node is LateUpdateComponent:
      node.initialize()
      _late_update_components.append(node)
  if _skill_ai:
    _skill_ai.skill_used.connect(_on_skill_used)

func set_cell(target_cell: Vector2i):
  cell = target_cell
  global_position = map_manager.cell_id_to_global_position(target_cell)

func _on_map_initialized():
  var target_cell = map_manager.random_cell_in_rooms()
  set_cell(target_cell)

func _on_character_dead(character: Character):
  if character == self and !character.is_dead:
    _astar_grid_manager.astar_grid.set_point_solid(
      map_manager.position_to_cell_id(global_position),
      false
    )
    queue_free()
    is_dead = true

func _init_enemy():
  # load enemy data from EnemyList
  character_data = EnemyList.enmey_data(id)
  # set sprite
  _sprite.texture = load("res://asset/texture/enemy/"+character_data.key+".tres")

  
func _on_skill_used():
  pass
