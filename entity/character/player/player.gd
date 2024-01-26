extends Character
class_name Player

func initialize():
  super.initialize()
  map_manager.initialized.connect(_on_map_initialized)

func _on_map_initialized():
  cell = map_manager.random_cell_in_rooms()
  global_position = map_manager.cell_id_to_global_position(cell)

func _on_character_dead(character: Character):
  if character == self and !character.is_dead:
    # TODO : Game Over
    print("Game Over")
    is_dead = true
  
