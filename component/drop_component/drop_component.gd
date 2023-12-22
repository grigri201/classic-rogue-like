extends LateUpdateComponent

var _pickable_object_container;

func initialize():
  _pickable_object_container = get_tree().current_scene.get_node("%PickableObjectContainer")

func update():
  pass
    
func try_drop_pickable_object():
  if !(owner is Enemy) or !owner.is_dead:
    return
  for object in owner.character_data.death_drop_pickable_objects.keys():
    var drop_probability = owner.character_data.death_drop_pickable_objects[object]
    if (randf_range(0, 1) > drop_probability):
      continue
    var drop = object.instantiate()
    _pickable_object_container.add_child(drop)
    drop.global_position = owner.global_position
    drop.initialize()
    break

func late_update():
  try_drop_pickable_object()
    
