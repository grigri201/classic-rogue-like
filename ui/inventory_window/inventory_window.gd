extends UI
class_name InventoryWindow

var _inventory_object_scene: PackedScene
var _inventory_container: VBoxContainer
var _description_label: Label
var _selected_inventory_index: int = 0
var _player: Player
var _input_handler: InputHandler

func initialize():
  _inventory_object_scene = load("res://ui/inventory_window/inventory_object/inventory_object.tscn")
  _inventory_container = get_node("%InventoryContainer")
  _description_label = get_node("%DescriptionLabel")
  _player = get_tree().current_scene.get_node("%Player")
  _input_handler = get_tree().current_scene.get_node("%InputHandler")

  _input_handler.toggle_inventory_window_input.connect(toggle)

func update():
  pass

func use_inventory_object():
  var player_data = _player.character_data
  if player_data.inventory.size() == 0:
    return
  var picked_object = player_data.inventory[_selected_inventory_index]
  if picked_object is ConsumableItem:
    picked_object.consume()
  elif picked_object is Equipment:
    picked_object.equip()
  toggle()

func drop_inventory_object():
  var player_data = _player.character_data
  if player_data.inventory.size() == 0:
    return
  var picked_object = player_data.inventory[_selected_inventory_index]
  if picked_object is ImmediateEffectItem:
    picked_object.undo_immediate_effect()
  player_data.inventory.remove_item(_selected_inventory_index)
  toggle()

func generate_inventory_objects():
  var player_data = _player.character_data
  if player_data.inventory.size() == 0:
    return
  for i in range(player_data.inventory.size()):
    var object = player_data.inventory[i]
    var inventory_object = _inventory_object_scene.instantiate()
    inventory_object.text = "{index}. {name}".format({ "index": (i + 1), "name": object.object_name })
    _inventory_container.add_child(inventory_object)
    inventory_object.initialize()
    inventory_object.selected.connect(_on_inventory_object_selected)
  _inventory_container.get_child(0).grab_focus()

func clear_inventory_container():
  for child in _inventory_container.get_children():
    child.queue_free()
  _description_label.text = ""

func toggle():
  visible = !visible
  if visible:
    generate_inventory_objects()
  else:
    clear_inventory_container()

func _on_inventory_object_selected(focused_object: InventoryObject):
  var player_data = _player.character_data
  if player_data.inventory.size() == 0:
    return
  _selected_inventory_index = focused_object.get_index()
  var object = player_data.inventory[_selected_inventory_index]
  _description_label.text = object.description
