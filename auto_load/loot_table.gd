extends Node

var content : Dictionary

func _ready():
  var file = FileAccess.open("res://auto_load/loot_table.json", FileAccess.READ)
  content = JSON.parse_string(file.get_as_text())
  file.close()

func get_key(ID = "0"):
  return content[ID]["texture"]

func get_item_name(ID = "0"):
  return content[ID]["name"]

func get_description(ID = "0"):
  return content[ID]["description"]

func get_stack_size(ID = "0"):
  return content[ID]["stack_size"]

func get_health_increase(ID = "0"):
  return content[ID]["health_increase"]

func get_satiety_increase(ID = "0"):
  return content[ID]["satiety_increase"]
