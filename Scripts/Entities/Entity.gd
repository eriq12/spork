extends Node2D

class_name Entity

onready var sprite : Sprite = $Sprite
onready var animator : AnimationPlayer = $AnimationPlayer

var location : Vector2

enum DIRECTION { DOWN, LEFT, RIGHT, UP }
const anim_name = [ "walk_down", "walk_left", "walk_right", "walk_up" ]
const direction_vec = [Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP]

var _moving_direction : int = -1
var _looking_direction : int = DIRECTION.DOWN

onready var map : Node2D = get_parent()

func _process(_delta):
	if _moving_direction >= 0 and _moving_direction <= 3:
		set_look_direction(_moving_direction)
		if map.is_open(location + direction_vec[_moving_direction]):
			play_walk(_moving_direction)
	elif int(sprite.get_frame_coords().x) & 1 == 1:
		stop_walk()

func progress_walk():
	var coords = sprite.get_frame_coords()
	coords.x += 1
	if coords.x >= sprite.hframes:
		coords.x = 0
	sprite.set_frame_coords(coords)

func get_look_direction() -> int:
	return _looking_direction

func set_look_direction(new_direction : int):
	if not _looking_direction == new_direction:
		sprite.set_frame_coords(Vector2(0, new_direction))
		_looking_direction = new_direction

func play_walk(direction : int):
	self.set_process(false)
	animator.play(anim_name[direction])
	yield(animator, "animation_finished")
	self.set_process(true)

func stop_walk():
	var coords = sprite.get_frame_coords()
	coords.x = 0
	sprite.set_frame_coords(coords)

func input_direction(direction: int):
	_moving_direction = direction

func get_grid_position() -> Vector2:
	return location

func move(direction_move:int):
	set_grid_position(location + direction_vec[direction_move])

func set_grid_position(new_location: Vector2):
	location = new_location
	get_parent().update_position(self, new_location)

func reset_states():
	animator.set_speed_scale(1.0)
	_moving_direction = -1

func focus():
	$Sprite/Camera2D.make_current()