extends GameState
class_name CombatState

var _combat_manager: CombatManager
var _enemy_container: Node
var _main_ui: MainUI

func initialize():
  _combat_manager = get_tree().current_scene.get_node("%CombatManager")
  _enemy_container = get_tree().current_scene.get_node("%EnemyContainer")
  _main_ui = get_tree().current_scene.get_node("%MainUi")
  
func update(_delta):
  _combat_manager.update(_delta)
  for enemy in _enemy_container.get_children():
    enemy.late_update(_delta)
  _main_ui.update(_delta)
  next_state.emit()
