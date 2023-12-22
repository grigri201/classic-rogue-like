extends ImmediateEffectItem

@export var scount_increment = 3

func initialize():
  super.initialize()

func do_immediate_effect():
  _player.chatacter_data.sight += scount_increment

func undo_immediate_effect():
  _player.chatacter_data.sight -= scount_increment
