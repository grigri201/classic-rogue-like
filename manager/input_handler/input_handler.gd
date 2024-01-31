extends Node
class_name InputHandler

signal movement_input(direction: Vector2i)
signal toggle_inventory_window_input()
signal skip_round_input()

var _interrupt_movement_timer: Timer
var _max_interrupt_time: float = 0.3
var _min_interrupt_time: float = 0.1
var _current_duration: float
var _player: Node2D
var _map_manager: MapManager
var _map_data: MapData
var _combat_manager: CombatManager
var _inventory_window: InventoryWindow
var _pickable_object_container: Node

func initialize():
  _interrupt_movement_timer = get_node("InterruptMovementTimer")
  _player = get_tree().current_scene.get_node("%Player")
  _map_manager = get_tree().current_scene.get_node("%MapManager")
  _map_data = _map_manager.map_data
  _combat_manager = get_tree().current_scene.get_node("%CombatManager")
  _inventory_window = get_tree().current_scene.get_node("%InventoryWindow")
  _pickable_object_container = get_tree().current_scene.get_node("%PickableObjectContainer")

func update(_delta):
  if _player.is_dead:
    return
  if handle_toggle_inventory_window_input():
    return
  if _inventory_window.visible:
    return
  if handle_skip_round_input():
    return
  handle_movement_input()

func handle_skip_round_input():
  if Input.is_action_just_pressed("skip_round"):
    skip_round_input.emit()
    return true
  return false

func handle_toggle_inventory_window_input():
  if Input.is_action_just_pressed("toggle_inventory_window"):
    toggle_inventory_window_input.emit()
    return true
  return false

func handle_movement_input() -> bool:
  var movement_direction = get_movement_direction()
  if movement_direction == Vector2i.ZERO:
    _current_duration = _max_interrupt_time
    return false
  if !_interrupt_movement_timer.is_stopped():
    return false
  _interrupt_movement_timer.start(_current_duration)
  _current_duration = _min_interrupt_time
  try_handle_attack(movement_direction)
  try_handle_pickup(movement_direction)
  movement_input.emit(movement_direction)
  return true;

func get_movement_direction():
  var movement_horizontal = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
  var movement_vertical = Input.get_action_strength("player_move_down") - Input.get_action_strength("player_move_up")
  # limit movment in 4 direction
  if movement_horizontal != 0 and movement_vertical != 0:
    return Vector2i.ZERO
  return Vector2i(Vector2(movement_horizontal, movement_vertical).sign())

func try_handle_attack(direction: Vector2i) -> bool:
  # TODO handle range attack later
  var target_position = Vector2i(_player.get_global_position()) + direction * _map_data.cell_size
  var result = _map_manager.intersection_points(target_position, MapEnum.PhysicsLayer().BLOCK_MOVEMENT, [])
  if result.size() == 0:
    return false
  for element in result:
    var collider = element["collider"]
    if (collider.owner is Enemy):
      _combat_manager.add_to_combat(_player, collider.owner)
  return true

func try_handle_pickup(direction: Vector2i):
  var target_position = Vector2i(_player.get_global_position()) + direction * _map_data.cell_size
  var result = _map_manager.intersection_points(target_position, MapEnum.PhysicsLayer().PICKABLE_OBJECT, [_player.get_node("CharacterBody2D").get_rid()])
  if result.size() == 0:
    return false
  for element in result:
    var collider = element["collider"]
    if (collider.owner is PickableObject):
      _player.character_data.add_inventory_item(collider.owner)
      collider.owner.visible = false
      _pickable_object_container.remove_child(collider.owner)
  return true
