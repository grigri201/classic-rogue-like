extends Character
class_name Enemy

var _late_update_components: Array[LateUpdateComponent] = []
var _astar_grid_manager: AstarGridManager

func initialize():
  super.initialize()
  _astar_grid_manager = get_tree().current_scene.get_node("%AstarGridManager")
  map_manager.initialized.connect(_on_map_initialized)
  var nodes = get_children()
  for node in nodes:
    if node is LateUpdateComponent:
      node.initialize()
      _late_update_components.append(node)

func _on_map_initialized():
  var enemy_spawn_cell = map_manager.random_cell_in_rooms()
  global_position = map_manager.cell_id_to_global_position(enemy_spawn_cell)

func _on_character_dead(character: Character):
  if character == self and !character.is_dead:
    _astar_grid_manager.astar_grid.set_point_solid(
      map_manager.position_to_cell_id(global_position),
      false
    )
    queue_free()
    is_dead = true
  