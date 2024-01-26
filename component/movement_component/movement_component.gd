extends Component

var _input_handler: InputHandler
var _current_direction: Vector2i = Vector2i.ZERO
var _map_manager: MapManager
var _map_data: MapData
var _astar_grid_manager: AstarGridManager
var _animation_player: AnimationPlayer
var _character_body: CharacterBody2D

func initialize():
  _map_manager = get_tree().current_scene.get_node("%MapManager")
  _map_data = _map_manager.map_data
  _astar_grid_manager = get_tree().current_scene.get_node("%AstarGridManager")
  _animation_player = owner.get_node("AnimationPlayer")
  _character_body = owner.get_node("CharacterBody2D")
  if owner is Enemy and owner.has_node("AiComponent"):
    if owner.has_node("AiComponent/SquareMoveAi"):
      owner.get_node("AiComponent/SquareMoveAi").executed.connect(_on_square_move_executed)
    if owner.has_node("AiComponent/WalkAroundAi"):
      owner.get_node("AiComponent/WalkAroundAi").executed.connect(_on_walk_around_executed)
    if owner.has_node("AiComponent/ChaseAi"):
      owner.get_node("AiComponent/ChaseAi").executed.connect(_on_chase_executed)
  elif owner is Player:
    _input_handler = get_tree().current_scene.get_node("%InputHandler")
    _input_handler.movement_input.connect(_on_movement_input)

func update(_delta):
  if _current_direction == Vector2i.ZERO:
    return
  if is_movemnt_blocked():
    _current_direction = Vector2i.ZERO
    return
  # set old cell solid false if enemy
  try_set_enemy_cell_solid(false)
  owner.cell += _current_direction
  # set new cell solid true if enemy
  try_set_enemy_cell_solid(true)
  move_to_target_position()
  if _animation_player.has_animation("move"):
    _animation_player.play("move")
  _current_direction = Vector2.ZERO

func move_to_target_position():
  var tween = owner.create_tween().bind_node(owner).set_trans(Tween.TRANS_QUART)
  tween.tween_property(owner, "position", _map_manager.cell_id_to_global_position(owner.cell), 0.2)

func is_movemnt_blocked():
  var target_position = _map_manager.cell_id_to_global_position(owner.cell + _current_direction)
  var results = _map_manager.intersection_points(target_position, MapEnum.PhysicsLayer().BLOCK_MOVEMENT, [])
  if results.size() > 0:
    return true
  return false

func try_set_enemy_cell_solid(solid: bool):
  if owner is Enemy:
    _astar_grid_manager.astar_grid.set_point_solid(
      owner.cell,
      solid
    )

func _on_movement_input(direction: Vector2i):
  _current_direction = direction

func _on_walk_around_executed(direction: Vector2i):
  if _map_manager.try_to_move_character(owner.cell + direction):
    _current_direction = direction
  else:
    _current_direction = Vector2i.ZERO

func _on_square_move_executed(direction: Vector2i):
  if _map_manager.try_to_move_character(owner.cell + direction):
    _current_direction = direction
  else:
    _current_direction = Vector2i.ZERO

func _on_chase_executed(direction: Vector2i):
  if _map_manager.try_to_move_character(owner.cell + direction):
    _current_direction = direction
  else:
    _current_direction = Vector2i.ZERO
