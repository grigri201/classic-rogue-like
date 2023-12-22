extends Equipment

@export var _min_attack_increament = 3;
@export var _max_attack_increament = 20;

var _final_attack_increament;

func initialize():
  super.initialize()
  _final_attack_increament = randf_range(_min_attack_increament, _max_attack_increament)
  
func update():
  assert(false, "this method must be overriden")
  