extends GameState
class_name ActionState

var _map_manager: MapManager
# 处理玩家、敌人的行为逻辑
var _player: Player
var _enemy_container: Node
var _fog_painter: FogPainter

func initialize():
  _map_manager = get_tree().current_scene.get_node("%MapManager")
  _player = get_tree().current_scene.get_node("%Player")
  _enemy_container = get_tree().current_scene.get_node("%EnemyContainer")
  _fog_painter = get_tree().current_scene.get_node("%FogPainter")

func update(_delta):
  _player.update(_delta)
  for enemy in _enemy_container.get_children():
    enemy.update(_delta)
  _fog_painter.update(_delta)
  _map_manager.clear_character_move_cells()
  next_state.emit()
  