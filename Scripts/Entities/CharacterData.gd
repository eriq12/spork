class_name CharacterData

export var name : String setget set_name, get_name
var _max_health : int setget , get_max_health
var _current_health : int setget , get_current_health
export var appearance : StreamTexture setget set_appearance, get_appearance
const default_appearance : String = "res://Assets/TextureResources/CharacterAppearances/DefaultCharacter.png.tres"

signal health_changed(new_health)
signal max_health_changed(new_max_health)
signal appearnace_changed(new_appearance)

func _init(character_name="Bob", health=20, current_health=-1, image_appearnace=default_appearance):
	set_name(character_name)
	_set_max_health(int(max(health, 20)))
	_set_max_health(health if current_health < 0 else current_health)
	if bool(image_appearnace):
		appearance = load(image_appearnace)

### accessors

# get name
func get_name() -> String:
	return name

# get max health
func get_max_health() -> int:
	return _max_health

# get current health
func get_current_health() -> int:
	return _current_health

# get appearance
func get_appearance() -> StreamTexture:
	return appearance

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
func set_appearance(new_appearance : StreamTexture):
	appearance = new_appearance
	emit_signal("appearnace_changed", appearance)

func save_data() -> Dictionary:
	var save_data = {
		"Name" : name,
		"Max_Health" : _max_health,
		"Current_Health" : _current_health,
		"Appearance" : appearance.get_path() if appearance != null else default_appearance,
	}
	return save_data

func load_data(data_payload : Dictionary):
	# name
	set_name(data_payload.get("Name", "Lance"))
	# max health
	_set_max_health(data_payload.get("Max_Health", 20))
	# current health
	_set_health(data_payload.get("Current_Health", 20))
	# appearance
	set_appearance(load(data_payload.get("Appearance", default_appearance)))
