extends GameState
class_name StartState

# 状态循环的启动状态
# 初始化其他 entities 和 managers
# 在切换 scene 前不会再次进入本状态
var _input_handler: InputHandler
var _player: Player
var _enemy_spawner: EnemySpawner
var _map_manager: MapManager
var _inventory_window: InventoryWindow
var _astar_grid_manager: AstarGridManager

func initialize():
  _input_handler = get_tree().current_scene.get_node("%InputHandler")
  _player = get_tree().current_scene.get_node("%Player")
  _enemy_spawner = get_tree().current_scene.get_node("%EnemySpawner")
  _map_manager = get_tree().current_scene.get_node("%MapManager")
  _inventory_window = get_tree().current_scene.get_node("%InventoryWindow")
  _astar_grid_manager = get_tree().current_scene.get_node("%AstarGridManager")

  _input_handler.initialize()
  _player.initialize()
  _enemy_spawner.initialize()
  _map_manager.initialize()
  _inventory_window.initialize()
  # wait until frame is processed
  await get_tree().process_frame
  _astar_grid_manager.initialize()

func update():
  next_state.emit()
