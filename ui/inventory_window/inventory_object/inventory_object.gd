extends Button
class_name InventoryObject

signal selected(inventory_object: InventoryObject)

func initialize():
  focus_entered.connect(_on_focus_entered)

func update(_delta):
  pass

func _on_focus_entered():
  selected.emit(self)
