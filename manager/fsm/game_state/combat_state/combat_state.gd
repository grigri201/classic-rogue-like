extends GameState
class_name CombatState

var _combat_manager: CombatManager
var _enemy_container: Node

func initialize():
  _combat_manager = get_tree().current_scene.get_node("%CombatManager")
  _enemy_container = get_tree().current_scene.get_node("%EnemyContainer")
  
func update():
  _combat_manager.update()
  for enemy in _enemy_container.get_children():
    enemy.late_update()
  next_state.emit()
