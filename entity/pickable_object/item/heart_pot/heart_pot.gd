extends ImmediateEffectItem

@export var health_increase = 30

func initialize():
  super.initialize()

func do_immediate_effect():
  _player.character_data.hp = minf(_player.character_data.hp + health_increase, _player.character_data.max_hp)
  _player.character_data.inventory.remove_item(self)

func undo_immediate_effect():
  pass
