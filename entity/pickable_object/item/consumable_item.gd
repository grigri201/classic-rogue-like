extends Item
class_name ConsumableItem

# 使用就生效

func initialize():
  super.initialize()

func consume():
  assert(false, "this method must be overriden")
