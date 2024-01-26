extends CharacterData
class_name PlayerData

var level: int = 1
var experience: int = 0
var inventory: Array[InventoryItem] = []

@export var base_levelup_experience_threshold: int = 100
@export var levelup_experience_threshold_increament: float = 0.2

@export var base_attribute_points_gain_per_level: int = 5

func wrap_pickable_object(object: PickableObject) -> InventoryItem:
  var item = InventoryItem.new()
  item.initialize(object)
  return item

func add_inventory_item(object: PickableObject, amount: int = 1) -> void:
  print("add item:"+object.object_name+", amount:"+str(amount))
  if inventory.size() == 0:
    var item = wrap_pickable_object(object)
    var remaining = item.try_add_quantity(amount)
    inventory.append(item)
    while remaining > 0:
      var new_item = wrap_pickable_object(object)
      remaining = new_item.try_add_quantity(remaining)
      print("try add: ", new_item)
      inventory.append(new_item)
    print("after added:", inventory)
    return
  for i in range(inventory.size() - 1, -1, -1):
    var item = inventory[i]
    if item.object.id == object.id:
      var remaining = item.try_add_quantity(amount)
      while remaining > 0:
        var new_item = wrap_pickable_object(object)
        remaining = new_item.try_add_quantity(remaining)
        inventory.append(new_item)

func remove_inventory_item(item: InventoryItem, amount: int = 1) -> void:
  if inventory.size() == 0:
    return
  for i in range(inventory.size() - 1, -1, -1):
    var current_item = inventory[i]
    if current_item.object.id == item.object.id:
      var remaining = current_item.try_remove_quantity(amount)
      if remaining == 0:
        inventory.erase(i)
        return
      else:
        amount = remaining
