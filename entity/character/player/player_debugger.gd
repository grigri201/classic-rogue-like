extends Node

func _process(_delta):
  if (Input.is_action_just_pressed("show_player_attributes_debug_info")):
    var player = get_tree().current_scene.get_node("%Player")
    var character_data = player.character_data
    print("--------------------")
    print("name:", character_data.name)
    print("strength", player.strength)
    print("constitution:", character_data.constitution)
    print("agility:", character_data.agility)
    print("current_hp:", character_data.hp)
    print("max_hp:", character_data.max_hp)
    print("attack:", character_data.attack)
    print("defense:", character_data.defense)
    print("dodge:", character_data.dodge)
    print("critical:", character_data.critical)
    print("--------------------")
  if (Input.is_action_just_pressed("show_player_inventory_debug_info")):
    var player = get_tree().current_scene.get_node("%Player")
    var inventory = player.character_data.inventory
    print("--------------------")
    print("inventory:")
    for item in inventory:
      print("* ", item.name)
    print("--------------------")
  