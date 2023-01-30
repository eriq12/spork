extends LevelTemplate

func _ready():
	set_player($Player)
	set_tilemap($TileMap)
	$Player.focus()
