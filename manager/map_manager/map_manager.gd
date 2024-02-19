extends Node
class_name MapManager

signal initialized()

@export var map_data_list: Array[MapData]
var map_data: MapData
var map_generator: MapGenerator
var _character_spawn_cells: Array[Vector2i] = []
var _character_move_cells: Array[Vector2i] = []

func initialize():
  map_data = map_data_list[0]
  var child_count = get_child_count()
  assert(child_count == 1 and get_child(0) is MapGenerator)
  map_generator = get_child(0) as MapGenerator
  map_generator.initialize()
  initialized.emit()

func update(_delta):
  pass

func allocate_spawn_cell(cell: Vector2i):
  _character_spawn_cells.append(cell)

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

func intersect_ray(from: Vector2, to: Vector2, collision_mask: int, collide_with_area: bool, exclude: Array[RID]):
  var space = get_tree().current_scene.get_node("%Player").get_world_2d().direct_space_state
  var parameters = PhysicsRayQueryParameters2D.new()
  parameters.from = from
  parameters.to = to
  parameters.collision_mask = collision_mask
  parameters.exclude = exclude
  parameters.collide_with_areas = collide_with_area
  return space.intersect_ray(parameters)

func cell_intersect_ray(from: Vector2i, to: Vector2i, collision_mask: int, collide_with_area: bool, exclude: Array[RID]):
  var from_position = cell_id_to_global_position(from)
  var to_position = cell_id_to_global_position(to)
  return intersect_ray(from_position, to_position, collision_mask, collide_with_area, exclude)

func intersect_point(position: Vector2, collision_mask: int, collide_with_area: bool, exclude: Array[RID]):
  var space = get_tree().current_scene.get_node("%Player").get_world_2d().direct_space_state
  var parameters = PhysicsPointQueryParameters2D.new()
  parameters.position = position
  parameters.collision_mask = collision_mask
  parameters.exclude = exclude
  parameters.collide_with_areas = collide_with_area
  return space.intersect_point(parameters)

func cell_intersect_point(cell: Vector2i, collision_mask: int, collide_with_area: bool, exclude: Array[RID]):
  var position = cell_id_to_global_position(cell)
  return intersect_point(position, collision_mask, collide_with_area, exclude)

func try_to_move_character(cell: Vector2i) -> bool:
  if _character_move_cells.find(cell) == -1:
    _character_move_cells.append(cell)
    return true
  return false

func clear_character_move_cells():
  _character_move_cells.clear()
