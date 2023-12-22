extends Node
class_name GameState

signal next_state

func initialize():
    assert(false, "this method must be overriden")

func update():
    assert(false, "this method must be overriden")