extends CharacterData
class_name PlayerData

var level: int = 1
var experience: int = 0
var inventory: Array[PickableObject] = []

@export var base_levelup_experience_threshold: int = 100
@export var levelup_experience_threshold_increament: float = 0.2

@export var base_attribute_points_gain_per_level: int = 5
