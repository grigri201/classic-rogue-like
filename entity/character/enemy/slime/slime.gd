extends LateUpdateEnemy

var _map_manager: MapManager
var _enemy_spawner: EnemySpawner
var _slime_resource = load("res://entity/character/enemy/slime/slime.tscn")

func initialize():
  super.initialize()
  _map_manager = get_tree().current_scene.get_node("%MapManager")
  _enemy_spawner = get_tree().current_scene.get_node("%EnemySpawner")

func _on_skill_used():
  var target_cell = get_valid_cell()
  if target_cell != Vector2i.ZERO:
    _split_slime(target_cell)

func get_valid_cell():
  var directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT, Vector2i(-1, -1), Vector2i(-1, 1), Vector2i(1, -1), Vector2i(1, 1)]
  for direction in directions:
    var target_cell = cell + direction
    var block_move = _map_manager.cell_intersect_point(target_cell, MapEnum.PhysicsLayer().BLOCK_MOVEMENT, true, [])
    var pickable_item = _map_manager.cell_intersect_point(target_cell, MapEnum.PhysicsLayer().PICKABLE_OBJECT, true, [])
    if block_move.size() == 0 and pickable_item.size() == 0:
      return target_cell
  return Vector2i.ZERO
  
func _split_slime(_target_cell: Vector2i):
  pass
  # print(cell, " try to split slime to: ", target_cell)
  # _enemy_spawner.spawn_enemy(_slime_resource, target_cell)
