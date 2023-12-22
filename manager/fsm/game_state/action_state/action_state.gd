extends GameState
class_name ActionState

# 处理玩家、敌人的行为逻辑
var _player: Player

var _enemy_container: Node

func initialize():
  _player = get_tree().current_scene.get_node("%Player")
  _enemy_container = get_tree().current_scene.get_node("%EnemyContainer")

func update():
  _player.update()
  for enemy in _enemy_container.get_children():
    enemy.update()
  next_state.emit()
  