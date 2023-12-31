extends Node2D

var fsm: FSM

func _ready():
  fsm = get_node("%Fsm")
  fsm.initialize()

func _process(_delta):
  fsm.update(_delta);
