extends Node

var content : Dictionary

func _ready():
  var file = FileAccess.open("res://auto_load/loot_table.json", FileAccess.READ)
  content = JSON.parse_string(file.get_as_text())
  file.close()

func item_data(ID = "0"):
  var data = InventoryItemData.new()
  data.id = ID
  data.key = content[ID]["key"]
  data.name = content[ID]["name"]
  data.description = content[ID]["description"]
  data.stack_size = content[ID]["stack_size"]
  data.health_increase = content[ID]["health_increase"]
  data.satiety_increase = content[ID]["satiety_increase"]
