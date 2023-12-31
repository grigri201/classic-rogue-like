extends UI
class_name MainUI

var _player: Player

# HP
var _hp_bar: TextureProgressBar

# states
var _attack_label: Label
var _defense_label: Label
var _sight_label: Label

func initialize():
  _player = get_tree().current_scene.get_node("%Player")
  _hp_bar = get_node("TopContainer/UserStatePanel/HBoxContainer/VBoxContainer/HPProgressBarContainer/HPBar")
  _attack_label = get_node("TopContainer/UserStatePanel/HBoxContainer/VBoxContainer/States/HBoxContainer/AttackLabel")
  _defense_label = get_node("TopContainer/UserStatePanel/HBoxContainer/VBoxContainer/States/HBoxContainer/DefenseLabel")
  _sight_label = get_node("TopContainer/UserStatePanel/HBoxContainer/VBoxContainer/States/HBoxContainer/SightLabel")

func update(_delta):
  _hp_bar.max_value = _player.character_data.max_hp
  _hp_bar.value = _player.character_data.hp

  _attack_label.text = str(_player.character_data.attack)
  _defense_label.text = str(_player.character_data.defense)
  _sight_label.text = str(_player.character_data.sight)
