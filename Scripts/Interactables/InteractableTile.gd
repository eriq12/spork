extends Node

class_name InteractibleTile

# location
export var x : int
export var y : int

# appearance
export var tileset_index : int

export var atlas_index_x : int
export var atlas_index_y : int

# function to call when interacting with tile, returns whether it was successful
func Interact(target)->bool:
	return false
