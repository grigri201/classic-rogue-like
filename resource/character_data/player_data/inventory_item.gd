class_name InventoryItem

var item_icon: Texture2D
var quantity: int
var inventory_item_data: InventoryItemData

static func from_item_data(item_data: InventoryItemData):
  var item = InventoryItem.new()
  item.initialize(item_data)
  return item

func initialize(item_data: InventoryItemData):
  inventory_item_data = item_data
  item_icon = load("res://ui/texture/inventory/"+item_data.name+".tres")
  quantity = 0

func try_add_quantity(amount: int):
  var finally_quantity = quantity + amount
  if finally_quantity > inventory_item_data.stack_size:
    quantity = inventory_item_data.stack_size
    return finally_quantity - inventory_item_data.stack_size
  quantity += amount
  return 0

func is_reach_max_stack():
  return quantity == inventory_item_data.stack_size

func try_remove_quantity(amount: int):
  var finally_quantity = quantity - amount
  if finally_quantity <= 0:
    var remaining = amount - quantity
    quantity = 0
    return remaining
  quantity -= amount
  return 0
