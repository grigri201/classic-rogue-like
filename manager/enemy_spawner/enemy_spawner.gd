extends Node
class_name EnemySpawner

@export var max_enemy = 30
@export var boss_scene: Dictionary = {}
@export var enemy_scene: Dictionary = {}

var _enemy_container: Node
var _enemy_count = 0

func initialize():
  _enemy_container = get_tree().current_scene.get_node("%EnemyContainer")
  spawn_enemy()
  sapwn_boss()

func update():
  pass

# TODO: improve spawn algorithm
func spawn_enemy():
  for enemy_resource in enemy_scene:
    if _enemy_count == max_enemy:
      break
    var enemy = enemy_resource.instantiate()
    _enemy_container.add_child(enemy)
    _enemy_count += 1
    enemy.initialize()

func sapwn_boss():
  for boss_resource in boss_scene:
    var boss = boss_resource.instantiate()
    _enemy_container.add_child(boss)
    boss.initialize()
