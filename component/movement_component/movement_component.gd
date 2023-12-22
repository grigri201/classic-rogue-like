extends Component

var _input_handler: InputHandler
var _current_direction: Vector2 = Vector2.ZERO
var _map_manager: MapManager
var _map_data: MapData
var _astar_grid_manager: AstarGridManager

func initialize():
  _map_manager = get_tree().current_scene.get_node("%MapManager")
  _map_data = _map_manager.map_data
  _astar_grid_manager = get_tree().current_scene.get_node("%AstarGridManager")
  if owner is Enemy and owner.has_node("AiComponent"):
    if owner.has_node("AiComponent/WalkAroundAi"):
      owner.get_node("AiComponent/WalkAroundAi").executed.connect(_on_walk_around_executed)
    if owner.has_node("AiComponent/ChaseAi"):
      owner.get_node("AiComponent/ChaseAi").executed.connect(_on_chase_executed)
  elif owner is Player:
    _input_handler = get_tree().current_scene.get_node("%InputHandler")
    _input_handler.movement_input.connect(_on_movement_input)

func update():
  try_set_enemy_cell_solid(owner)
  if _current_direction == Vector2.ZERO:
    return
  if is_movemnt_blocked():
    _current_direction = Vector2.ZERO
    return
  # TODO: use map grid to calculate movement position
  owner.global_position += _current_direction * Vector2(_map_data.cell_size)
  _current_direction = Vector2.ZERO

func is_movemnt_blocked():
  var target_position = owner.global_position + _current_direction * Vector2(_map_data.cell_size)
  var results = _map_manager.intersection_points(target_position, MapEnum.PhysicsLayer().BLOCK_MOVEMENT, [])
  if results.size() > 0:
    return true
  return false

func try_set_enemy_cell_solid(enemy: Node2D):
  if enemy is Enemy:
    _astar_grid_manager.astar_grid.set_point_solid(
      _map_manager.position_to_cell_id(enemy.global_position),
      true
    )

func _on_movement_input(direction: Vector2):
  _current_direction = direction

func _on_walk_around_executed(direction: Vector2i):
  _current_direction = direction

func _on_chase_executed(direction: Vector2i):
  _current_direction = direction
