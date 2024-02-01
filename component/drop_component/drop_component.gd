extends LateUpdateComponent

var _pickable_object_container;

func initialize():
  _pickable_object_container = get_tree().current_scene.get_node("%PickableObjectContainer")

func update(_delta):
  pass
    
func try_drop_pickable_object():
  if !(owner is Enemy) or !owner.is_dead:
    return
  for item_id in owner.character_data.loot_table.keys():
    var drop_probability = owner.character_data.loot_table[item_id]
    var random_num = randf_range(0, 1)
    if (random_num > drop_probability):
      continue
    var item_data = LootTable.item_data(item_id)
    var drop = PickableObject.from_inventory_item_data(item_data)
    _pickable_object_container.add_child(drop)
    drop.global_position = owner.global_position
    break

func late_update(_delta):
  try_drop_pickable_object()
    
