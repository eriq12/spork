extends Node

class_name InteractableTile

# location
export var x : int
export var y : int

# appearance
export var tileset_index : int

export var atlas_index_x : int
export var atlas_index_y : int

# signal
signal prompt(prompt_panel)

# panel
var panel : Control

# function to call when interacting with tile, returns whether it was successful
func interact()->bool:
	emit_signal("prompt", panel)
	return true

func _set_panel(new_panel : Control):
	panel = new_panel