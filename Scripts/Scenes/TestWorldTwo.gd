extends LevelTemplate

func _ready():
    set_walls($Walls)
    set_ground($GroundTiles)
    initialize_warp_tiles($Warps)