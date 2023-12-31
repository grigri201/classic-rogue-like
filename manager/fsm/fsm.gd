extends Node
class_name FSM

var _start_state: StartState
var _wait_for_input_state: WaitForInputState
var _action_state: ActionState
var _combat_state: CombatState

var _current_state: GameState

func initialize():
  # init states
  _start_state = get_node("StartState")
  _wait_for_input_state = get_node("WaitForInputState")
  _action_state = get_node("ActionState")
  _combat_state = get_node("CombatState")

  _current_state = _start_state

  # connect state changed signals
  _start_state.next_state.connect(_on_start_state_changed)
  _wait_for_input_state.next_state.connect(_on_wait_for_input_state_changed)
  _action_state.next_state.connect(_on_action_state_changed)
  _combat_state.next_state.connect(_on_combat_state_changed)

  # init states
  _start_state.initialize()
  _wait_for_input_state.initialize()
  _action_state.initialize()
  _combat_state.initialize()

func update(_delta):
  _current_state.update(_delta)

func _on_start_state_changed():
  _current_state = _wait_for_input_state

func _on_wait_for_input_state_changed():
  _current_state = _action_state

func _on_action_state_changed():
  _current_state = _combat_state

func _on_combat_state_changed():
  _current_state = _wait_for_input_state
