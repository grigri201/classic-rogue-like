extends Button

var _player: Player
var _player_data: PlayerData

@export var items: Array[PackedScene] = []

func _ready():
  _player = get_tree().current_scene.get_node("%Player")
  _player_data = _player.character_data

func _on_pressed():
  print("add random item pressed")
  var item = _random_item().instantiate()
  # var amount = _random_amount()
  _player_data.add_inventory_item(item, 1)
  print(_player_data.inventory)

func _random_item():
  return items[randi() % items.size()]

func _random_amount():
  return randi() % 10 + 1
