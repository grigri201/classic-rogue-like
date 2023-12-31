extends GameState
class_name WaitForInputState

# 响应 input_handler 的信号
# 没有输入事件的时候，本状态监听并阻断状态循环
var _input_handler: InputHandler

func initialize():
  _input_handler = get_tree().current_scene.get_node("%InputHandler")
  _input_handler.movement_input.connect(on_movement_input)
  _input_handler.skip_round_input.connect(on_skip_round_input)

func update(_delta):
  _input_handler.update(_delta)

func on_movement_input(_direction: Vector2i):
  next_state.emit()

func on_skip_round_input():
  next_state.emit()
