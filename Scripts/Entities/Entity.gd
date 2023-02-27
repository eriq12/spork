extends Node2D

class_name Entity

onready var sprite : Sprite = $Sprite
onready var animator : AnimationPlayer = $AnimationPlayer

var location : Vector2

enum DIRECTION { DOWN, LEFT, RIGHT, UP }
const anim_name = [ "walk_down", "walk_left", "walk_right", "walk_up" ]
const direction_vec = [Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP]

var _moving_direction : int = -1 setget set_look_direction, get_look_direction
var _looking_direction : int = DIRECTION.DOWN

signal movement_complete

onready var game_master : Node = get_node("/root/GameMaster")

func _process(_delta):
	# if a direction has been set to move, then move
	if _moving_direction >= 0 and _moving_direction <= 3:
		set_look_direction(_moving_direction)
		# checks with game master if the desired tile is free
		if game_master.is_open(location + direction_vec[_moving_direction]):
			play_walk(_moving_direction)
	# otherwise reset walk and stop moving
	elif int(sprite.get_frame_coords().x) & 1 == 1:
		stop_walk()

# progresses the walk animation (no actual change in position, fully aesthetics)
func progress_walk():
	var coords = sprite.get_frame_coords()
	coords.x += 1
	if coords.x >= sprite.hframes:
		coords.x = 0
	sprite.set_frame_coords(coords)

# accessor for look direction
func get_look_direction() -> int:
	return _looking_direction

# mutator for look direction
func set_look_direction(new_direction : int):
	if not _looking_direction == new_direction:
		sprite.set_frame_coords(Vector2(0, new_direction))
		_looking_direction = new_direction

# sets off the animations for walking along with actual positon change
func play_walk(direction : int):
	self.set_process(false)
	animator.play(anim_name[direction])
	yield(animator, "animation_finished")
	emit_signal("movement_complete")
	self.set_process(true)

# stops subsequent movement
func stop_walk():
	var coords = sprite.get_frame_coords()
	coords.x = 0
	sprite.set_frame_coords(coords)

# mutator for the direction the entity will move
func input_direction(direction: int):
	_moving_direction = direction

# gets the entity's current recorded grid position
func get_grid_position() -> Vector2:
	return location

# wrapped method for set_grid_position that is made to be based on current postition
func move(direction_move:int):
	set_grid_position(location + direction_vec[direction_move])

# calls changes to the entity's position
func set_grid_position(new_location: Vector2):
	location = new_location
	var parent = get_parent()
	if parent.has_method("update_position"):
		parent.update_position(self, new_location)

# resets the animation speed and moving direction of entity
func reset_states():
	animator.set_speed_scale(1.0)
	_moving_direction = -1

# DEPRECATED: makes camera child current
func focus():
	$Sprite/Camera2D.make_current()
