extends Node2D

class_name LevelTemplate

# base variables
var player_sprite : Entity
var walls : TileMap
var ground : TileMap
var interactibles : TileMap

## player section

func get_player() -> Entity:
	return player_sprite

func set_player(player : Entity):
	player_sprite = player

## walls

func get_walls() -> TileMap:
	return walls

func set_walls(new_map : TileMap):
	walls = new_map

func no_wall(x : int, y : int) -> bool:
	return walls == null or walls.get_cell(x, y) == -1

## interactibles

func get_interactibles() -> TileMap:
	return interactibles

func set_interactibles(new_map : TileMap):
	interactibles = new_map

func no_interactible(x : int, y : int) -> bool:
	return interactibles == null or interactibles.get_cell(x,y) == -1

## ground

func get_ground() -> TileMap:
	return ground

func set_ground(new_map : TileMap):
	ground = new_map

func has_ground(x : int, y : int) -> bool:
	return ground == null or ground.get_cell(x, y) != -1

## entities / locations / interaction

func update_position(child_node : Entity, new_position : Vector2):
	child_node.set_position(ground.map_to_world(new_position))

func is_open(new_location : Vector2) -> bool:
	var x = int(new_location.x)
	var y = int(new_location.y)
	return no_wall(x, y) and has_ground(x, y) and no_interactible(x, y)

func interact(x : int, y : int):
	pass
