extends CharacterData
class_name PlayerData

signal inventory_changed

var level: int = 1
var experience: int = 0
var inventory: Array[InventoryItem] = []

@export var base_levelup_experience_threshold: int = 100
@export var levelup_experience_threshold_increament: float = 0.2

@export var base_attribute_points_gain_per_level: int = 5

func add_inventory_item(item_data: InventoryItemData, amount: int = 1) -> void:
  var remaining = amount
  # try to stack with existing item
  for i in range(inventory.size() - 1, -1, -1):
    var item = inventory[i]
    if !item.is_reach_max_stack() and item.inventory_item_data.id == item_data.id:
      remaining = item.try_add_quantity(amount)
      try_add_new_item_stacked(item_data, remaining)
      remaining = 0
  try_add_new_item_stacked(item_data, remaining)
  inventory_changed.emit()

func try_add_new_item_stacked(item_data: InventoryItemData, amount: int) -> void:
  if amount == 0:
    return
  var remaining = amount
  while remaining > 0:
    var new_item = InventoryItem.from_item_data(item_data)
    remaining = new_item.try_add_quantity(remaining)
    inventory.append(new_item)

func remove_inventory_item(item: InventoryItem, amount: int = 1) -> void:
  if !inventory.has(item):
    return
  var remaining = item.try_remove_quantity(amount)
  if remaining == 0:
    inventory.erase(item)
  inventory_changed.emit()

func remove_inventory_item_by_index(index: int, amount: int = 1) -> void:
  if inventory.size() == 0:
    return
  var item = inventory[index]
  remove_inventory_item(item, amount)

func remove_inventory_item_by_object(item_data: InventoryItemData, amount: int = 1) -> void:
  if inventory.size() == 0:
    return
  for i in range(inventory.size() - 1, -1, -1):
    var current_item = inventory[i]
    if current_item.inventory_item_data.id == item_data.id:
      remove_inventory_item_by_index(i, amount)
