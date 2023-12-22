extends Node
class_name MapManager

signal initialized()

@export var map_data: MapData
var map_generator: MapGenerator
var _character_spawn_cells: Array[Vector2i] = []

func initialize():
  var child_count = get_child_count()
  assert(child_count == 1 and get_child(0) is MapGenerator)
  map_generator = get_child(0) as MapGenerator
  map_generator.initialize()
  initialized.emit()

func update():
  pass

func is_cell_spawnable(cell: Vector2i) -> bool:
  return _character_spawn_cells.find(cell) == -1

func random_cell_in_rooms() -> Vector2i:
  return map_generator.random_cell_in_rooms()

func cell_id_to_global_position(cell: Vector2i) -> Vector2:
  return cell * map_data.cell_size + map_data.cell_size / 2

func position_to_cell_id(position: Vector2) -> Vector2i:
  return (Vector2i(position) - map_data.cell_size / 2) / map_data.cell_size

func intersection_points(position: Vector2, collision_mask: int,exclude: Array[RID]) -> Array:
  var space = get_tree().current_scene.get_node("%Player").get_world_2d().direct_space_state
  var parameters = PhysicsPointQueryParameters2D.new()
  parameters.position = position
  parameters.collide_with_areas = true
  parameters.collision_mask = collision_mask
  parameters.exclude = exclude
  return space.intersect_point(parameters)

func cell_intersection_points(cell: Vector2i, collision_mask: int,exclude: Array[RID]) -> Array:
  var target_position = cell_id_to_global_position(cell)
  return intersection_points(target_position, collision_mask, exclude)
