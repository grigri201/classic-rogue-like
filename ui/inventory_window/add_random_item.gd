extends Button

var _player: Player
var _player_data: PlayerData

@export var items: Array[int] = []

func _ready():
  _player = get_tree().current_scene.get_node("%Player")
  _player_data = _player.character_data

func _on_pressed():
  var item_data = LootTable.item_data(_random_item())
  var amount = _random_amount()
  _player_data.add_inventory_item(item_data, amount)

func _random_amount():
  return randi() % 10 + 1

func _random_item():
  return str(items[randi() % items.size()])
