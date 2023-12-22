extends Item
class_name ImmediateEffectItem

func initialize():
  super.initialize()

func do_immediate_effect():
  assert(false, "this method must be overriden")

func undo_immediate_effect():
  assert(false, "this method must be overriden")
