extends LevelTemplate

var interactible_objects : Dictionary

func _ready():
	var interactible_tiles = $InteractableTiles
	set_player($Player)
	set_walls($Walls)
	set_ground($GroundTiles)
	set_interactibles(interactible_tiles)
	$Player.focus()
	
	var game_master = get_tree().root.get_node("GameMaster")
	
	for interactible in $Interactables.get_children():
		var location : Vector2 = Vector2(interactible.x, interactible.y)
		interactible_objects[location] = interactible
		interactible_tiles.set_cell(interactible.x, interactible.y, interactible.tileset_index, false, false, false, Vector2(interactible.atlas_index_x, interactible.atlas_index_y))
		interactible.connect("prompt", game_master, "prompt_overworld_player")

func interact(x : int, y : int):
	var location : Vector2 = Vector2(x, y)
	if interactible_objects.has(location) and interactible_objects[location] is InteractibleTile:
		interactible_objects[location].interact()
