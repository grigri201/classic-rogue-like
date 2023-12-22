extends Item
class_name DeadEffectItem

func initialize():
  super.initialize()

# yield func ?
func do_dead_effect():
  assert(false, "this method must be overriden")
