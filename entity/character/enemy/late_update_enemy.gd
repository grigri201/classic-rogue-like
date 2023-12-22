extends Enemy
class_name LateUpdateEnemy

func initialize():
  super.initialize()

func late_update():
  for component in _late_update_components:
    component.late_update()
