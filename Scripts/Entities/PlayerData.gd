class_name PlayerData

export var name : String
var _max_health : int
var _current_health : int
export var appearance : ImageTexture

signal health_changed(new_health)
signal max_health_changed(new_max_health)

func _init(character_name="Bob", health=20, current_health=-1, image_appearnace=""):
	name = character_name
	_max_health = health
	_current_health = _max_health if current_health < 0 else current_health
	if image_appearnace.length() > 0:
		appearance = load(image_appearnace)
