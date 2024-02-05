extends Node

var content : Dictionary

func _ready():
  var file = FileAccess.open("res://auto_load/enemy.json", FileAccess.READ)
  content = JSON.parse_string(file.get_as_text())
  file.close()

func enmey_data(ID = "0") -> EnemyData:
  print(typeof(content))
  var enemy_data = EnemyData.new()
  enemy_data.id = ID
  enemy_data.key = content[ID]["key"]
  enemy_data.name = content[ID]["name"]
  enemy_data.hp = content[ID]["hp"]
  enemy_data.max_hp = content[ID]["max_hp"]
  enemy_data.attack = content[ID]["attack"]
  enemy_data.defense = content[ID]["defense"]
  enemy_data.dodge = content[ID]["dodge"]
  enemy_data.critical = content[ID]["critical"]
  enemy_data.sight = content[ID]["sight"]
  enemy_data.speed = content[ID]["speed"]
  enemy_data.skill_cooldown = content[ID]["skill_cooldown"]
  enemy_data.experience = content[ID]["experience"]
  enemy_data.loot_table = content[ID]["loot_table"]
  return enemy_data
