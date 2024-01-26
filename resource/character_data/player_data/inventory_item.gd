class_name InventoryItem

var item_icon: Texture2D
var quantity: int
var pickable_object: PickableObject

func initialize(object: PickableObject):
  pickable_object = object
  item_icon = load("res://ui/texture/inventory/"+object.object_name+".tres")
  quantity = 0

func try_add_quantity(amount: int):
  var finally_quantity = quantity + amount
  if finally_quantity > pickable_object.stack_size:
    quantity = pickable_object.stack_size
    return amount - (finally_quantity - pickable_object.stack_size)
  quantity += amount
  return 0

func is_reach_max_stack():
  return quantity == pickable_object.stack_size

func try_remove_quantity(amount: int):
  var finally_quantity = quantity - amount
  if finally_quantity <= 0:
    var remaining = amount - quantity
    quantity = 0
    return remaining
  quantity -= amount
  return 0
