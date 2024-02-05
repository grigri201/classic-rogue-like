extends Node
class_name EnemySpawner

@export var max_enemy = 100
@export var boss_scene: Dictionary = {}
@export var enemy_scene: Dictionary = {}

var _enemy_container: Node
var _enemy_count = 0

func initialize():
  _enemy_container = get_tree().current_scene.get_node("%EnemyContainer")
  spawn_all_enemy()
  spawn_all_boss()

func update(_delta):
  pass

# TODO: improve spawn algorithm
func spawn_all_enemy():
  for enemy_resource in enemy_scene:
    if _enemy_count >= max_enemy:
      break
    var enemy_count = enemy_scene[enemy_resource]
    for i in range(enemy_count):
      spawn_enemy(enemy_resource)

func spawn_all_boss():
  for boss_resource in boss_scene:
    var boss = boss_resource.instantiate()
    _enemy_container.add_child(boss)
    boss.initialize()

func spawn_enemy(enemy: PackedScene, cell:= Vector2i.ZERO):
  var enemy_instance = enemy.instantiate()
  _enemy_container.add_child(enemy_instance)
  _enemy_count += 1
  enemy_instance.initialize()
  if cell != Vector2i.ZERO:
    enemy_instance.set_cell(cell)
