extends Resource
class_name CharacterData

@export var name: String

@export var sight: int

@export var strength: int
@export var constitution: int
@export var agility: int

@export var strength_increament_effects: Dictionary = {
  "attack": 2,
  "defense": 1,
}
@export var constitution_increament_effects: Dictionary = {
  "max_health": 3,
  "health": 3,
}
@export var agility_increament_effects: Dictionary = {
  "dodge": 0.01,
  "critical": 0.01,
}

var hp: float
var max_hp: float
var attack: float
var defense: float
var dodge: float
var critical: float
