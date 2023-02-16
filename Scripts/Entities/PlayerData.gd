class_name PlayerData

export var name : String
var _max_health : int
var _current_health : int
export var appearance : ImageTexture

signal health_changed(new_health)
signal max_health_changed(new_max_health)
signal appearnace_changed(new_appearance)

func _init(character_name="Bob", health=20, current_health=-1, image_appearnace=""):
	set_name(character_name)
	_set_max_health(health)
	_set_max_health(health if current_health < 0 else current_health)
	if image_appearnace.length() > 0:
		appearance = load(image_appearnace)

### mutators

## change by delta

# current health mutator by delta
func change_health(health_delta : int):
	_set_health(_current_health + health_delta)

# max health mutator by delta
func change_max_health(max_health_delta : int):
	_set_max_health(_max_health + max_health_delta)

## set value entirely

# name mutator
func set_name(new_name : String):
	name = new_name

# current health mutator
func _set_health(new_health : int):
	_current_health = new_health
	emit_signal("health_changed", new_health)

# max health mutator
func _set_max_health(new_max_health : int):
	_max_health = new_max_health
	emit_signal("max_health_changed", new_max_health)

# appearance texture mutator
func set_appearance(new_appearance : ImageTexture):
	appearance = new_appearance
	emit_signal("appearnace_changed", appearance)