extends Enemy
class_name LateUpdateEnemy

func initialize():
  super.initialize()

func late_update(_delta):
  for component in _late_update_components:
    component.late_update(_delta)
