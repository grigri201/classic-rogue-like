extends Component

var _ai_list = []

func initialize():
  var ai_nodes = get_children()
  for ai_node in ai_nodes:
    if ai_node is AI:
      ai_node.initialize()
      _ai_list.append(ai_node)

func update():
  for ai_node in _ai_list:
    var is_executed = ai_node.execute()
    if (is_executed):
      break
    
