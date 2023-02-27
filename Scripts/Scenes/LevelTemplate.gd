extends Node2D

class_name LevelTemplate

# base variables
var walls : TileMap
var ground : TileMap
var interactables : TileMap
var interactable_objects : Dictionary
var warp_tiles : TileMap
# a bit redundant, but eh
var warp_data : Array
export(TileSet) var interactables_tile_set : TileSet

## general

# ready initializes interactables and warps
func _ready():
	# initialize interactables 
	interactables = TileMap.new()
	interactables.set_tileset(interactables_tile_set)
	interactables.set_cell_size(Vector2(16,16))
	interactables.set_position(Vector2(-8,-8))
	self.add_child(interactables)

	# don't care about specifics for this tilemap as we won't be seeing it
	warp_tiles = TileMap.new()
	self.add_child(warp_tiles)

## walls

func get_walls() -> TileMap:
	return walls

func set_walls(new_map : TileMap):
	walls = new_map

func no_wall(x : int, y : int) -> bool:
	return walls == null or walls.get_cell(x, y) == -1

## interactables

func get_interactables() -> TileMap:
	return interactables

func initialize_interactables(parent : Node2D):
	var game_master = get_tree().root.get_node("GameMaster")
	
	for interactable in parent.get_children():
		var location : Vector2 = Vector2(interactable.x, interactable.y)
		interactable_objects[location] = interactable
		interactables.set_cell(interactable.x, interactable.y, interactable.tileset_index, false, false, false, Vector2(interactable.atlas_index_x, interactable.atlas_index_y))
		interactable.connect("prompt", game_master, "prompt_overworld_player")

func clear_interactables():
	pass

func no_interactable(x : int, y : int) -> bool:
	return interactables == null or interactables.get_cell(x,y) == -1

## ground

func get_ground() -> TileMap:
	return ground

func set_ground(new_map : TileMap):
	ground = new_map

func has_ground(x : int, y : int) -> bool:
	return ground == null or ground.get_cell(x, y) != -1

## entities / locations / interaction

func update_position(child_node : Entity, new_position : Vector2):
	# move child to position
	child_node.set_position(ground.map_to_world(new_position))
	# check if new tile is warp
	var index = warp_tiles.get_cell(int(new_position.x),int(new_position.y))
	yield(child_node, "movement_complete")
	if child_node is Player and index != -1:
		# if so, then wait for animation to stop before calling warp
		warp_data[index].enter_warp(child_node)

func is_open(new_location : Vector2) -> bool:
	var x = int(new_location.x)
	var y = int(new_location.y)
	return no_wall(x, y) and has_ground(x, y) and no_interactable(x, y)

func interact(x : int, y : int):
	var location : Vector2 = Vector2(x, y)
	if interactable_objects.has(location) and interactable_objects[location] is InteractableTile:
		interactable_objects[location].interact()

## warps

func initialize_warp_tiles(parent : Node2D):
	var game_master = get_tree().root.get_node("GameMaster")

	# for all warps
	for index in range(parent.get_child_count()):
		var warp_collection = parent.get_child(index)
		# add to list
		warp_data.push_back(warp_collection)
		# add respective warp tiles
		for warp_entry in warp_collection.get_warp_points():
			warp_tiles.set_cell(int(warp_entry.x), int(warp_entry.y), index)
		# connect signal to gm
		warp_collection.connect("warp", game_master, "load_map")

func clear_warp_tiles():
	pass