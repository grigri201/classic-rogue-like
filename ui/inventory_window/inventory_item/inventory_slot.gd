extends Button
class_name InventorySlot

signal selected(inventory_item: InventoryItem)

var icon_texture_rect: TextureRect
var quantity_label: Label
var inventory_item: InventoryItem

func initialize():
  focus_entered.connect(_on_focus_entered)
  icon_texture_rect = get_node("Icon")
  quantity_label = get_node("Quantity")

func set_item(item: InventoryItem):
  inventory_item = item
  set_icon()
  set_quantity()

func set_icon():
  icon_texture_rect.texture = inventory_item.item_icon

func set_quantity():
  quantity_label.text = str(inventory_item.quantity)

func update(_delta):
  pass

func _on_focus_entered():
  selected.emit(self)
