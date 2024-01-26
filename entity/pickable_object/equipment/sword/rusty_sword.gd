extends Equipment

@export var _min_attack_increament = 1;
@export var _max_attack_increament = 2;

var _final_attack_increament;

func initialize():
  super.initialize()
  _final_attack_increament = randf_range(_min_attack_increament, _max_attack_increament)
  
func update(_delta):
  assert(false, "this method must be overriden")
  