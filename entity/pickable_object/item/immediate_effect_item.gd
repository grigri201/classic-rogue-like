extends Item
class_name ImmediateEffectItem

# 装在背包里就生效

func initialize():
  super.initialize()

func do_immediate_effect():
  assert(false, "this method must be overriden")

func undo_immediate_effect():
  assert(false, "this method must be overriden")
