extends UI
class_name InventoryWindow

var _inventory_slot_scene: PackedScene
var _inventory_container: GridContainer
# var _description_label: Label
var _selected_inventory_index: int = 0
var _player: Player
var _input_handler: InputHandler

func initialize():
  _inventory_slot_scene = load("res://ui/inventory_window/inventory_item/inventory_slot.tscn")
  _inventory_container = get_node("%InventoryContainer")
  # _description_label = get_node("%DescriptionLabel")
  _player = get_tree().current_scene.get_node("%Player")
  _input_handler = get_tree().current_scene.get_node("%InputHandler")

  _input_handler.toggle_inventory_window_input.connect(toggle)

func update(_delta):
  pass

func use_inventory_item():
  var player_data = _player.character_data
  if player_data.inventory.size() == 0:
    return
  var picked_object = player_data.inventory[_selected_inventory_index]
  if picked_object is ConsumableItem:
    picked_object.consume()
  elif picked_object is Equipment:
    picked_object.equip()
  toggle()

func drop_inventory_item():
  var player_data = _player.character_data
  if player_data.inventory.size() == 0:
    return
  var picked_object = player_data.inventory[_selected_inventory_index]
  if picked_object is ImmediateEffectItem:
    picked_object.undo_immediate_effect()
  player_data.inventory.remove_item(_selected_inventory_index)
  toggle()

func generate_inventory_slots():
  var player_data = _player.character_data
  if player_data.inventory.size() == 0:
    return
  for i in range(player_data.inventory.size()):
    var item = player_data.inventory[i]
    var inventory_slot = _inventory_slot_scene.instantiate()
    _inventory_container.add_child(inventory_slot)
    inventory_slot.initialize()
    inventory_slot.set_item(item)
    inventory_slot.selected.connect(_on_inventory_item_selected)
  _inventory_container.get_child(0).grab_focus()

func clear_inventory_container():
  for child in _inventory_container.get_children():
    child.queue_free()
  # _description_label.text = ""

func toggle():
  visible = !visible
  if visible:
    generate_inventory_slots()
  else:
    clear_inventory_container()

func _on_inventory_item_selected(focused_object: InventorySlot):
  var player_data = _player.character_data
  if player_data.inventory.size() == 0:
    return
  _selected_inventory_index = focused_object.get_index()
  # var item = player_data.inventory[_selected_inventory_index]
  # print(item.object.object_name+" - "+str(item.quantity))
  # _description_label.text = item.description
