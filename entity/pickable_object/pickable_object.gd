extends Node2D
class_name PickableObject

var _sprite: Sprite2D

var inventory_item_data: InventoryItemData

static func from_inventory_item_data(item_data: InventoryItemData) -> PickableObject:
  var pickable_object = load("res://entity/pickable_object/item/"+item_data.key+"/"+item_data.key+".tscn")
  var drop = pickable_object.instantiate()
  drop.inventory_item_data = item_data
  drop.initialize()
  return drop

func initialize():
  _sprite = get_node("Sprite")
  _sprite.texture = load("res://ui/texture/inventory/"+inventory_item_data.key+".tres")
