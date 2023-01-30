extends Node2D

class_name LevelTemplate

# base variables
var player_sprite : Entity
var tile_map : TileMap

func get_player() -> Entity:
	return player_sprite

func set_player(player : Entity):
	player_sprite = player

func get_tilemap() -> TileMap:
	return tile_map

func set_tilemap(new_map : TileMap):
	tile_map = new_map

func update_position(child_node : Entity, new_position : Vector2):
	child_node.set_position(tile_map.map_to_world(new_position))

func is_open(new_location : Vector2) -> bool:
	return tile_map.get_cell(int(new_location.x), int(new_location.y)) == -1
