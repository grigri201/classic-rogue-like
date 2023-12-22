extends Item
class_name ConsumableItem

func initialize():
  super.initialize()

func consume():
  assert(false, "this method must be overriden")
