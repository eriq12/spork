extends Node2D

onready var _obstacle_map : TileMap = $ObstacleMap

## returns whether a coordinate is empty
func isSpotEmpty(x : int, y : int) -> bool:
	return _obstacle_map.get_cell(x, y) == TileMap.INVALID_CELL
	
