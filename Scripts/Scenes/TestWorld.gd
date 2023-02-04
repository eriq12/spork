extends LevelTemplate

var interactible_objects : Dictionary

func _ready():
	var interactible_tiles = $InteractableTiles
	set_player($Player)
	set_walls($Walls)
	set_ground($GroundTiles)
	set_interactibles(interactible_tiles)
	$Player.focus()
	
	for interactible in $Interactables.get_children():
		var location : Vector2 = Vector2(interactible.x, interactible.y)
		interactible_objects[location] = interactible
		interactible_tiles.set_cell(interactible.x, interactible.y, interactible.tileset_index, false, false, false, Vector2(interactible.atlas_index_x, interactible.atlas_index_y))

func interact(x : int, y : int):
	var location : Vector2 = Vector2(x, y)
	if interactible_objects.has(location):
		interactible_objects[location].interact()
