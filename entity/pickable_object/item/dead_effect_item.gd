extends Item
class_name DeadEffectItem

# 死亡的时候生效

func initialize():
  super.initialize()

# yield func ?
func do_dead_effect():
  assert(false, "this method must be overriden")
