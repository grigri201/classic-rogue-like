extends DeadEffectItem

@export var revive_delay_second = 2

func initialize():
  super.initialize()

func do_dead_effect():
  await get_tree().create_timer(revive_delay_second, false).timeout
  _player.character_data.hp = _player.character_data.max_hp
  _player.character_data.inventory.remove_item(self)
