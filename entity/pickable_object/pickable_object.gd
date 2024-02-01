extends Node2D
class_name PickableObject

var _sprite: Sprite2D

var inventory_item_data: InventoryItemData

func initialize():
  print(get_node("Sprite"))
  _sprite = get_node("Sprite")
  _sprite.texture = load("res://ui/texture/inventory/"+inventory_item_data.key+".tres")
