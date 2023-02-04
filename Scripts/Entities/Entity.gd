extends Node2D

class_name Entity

onready var sprite : Sprite = $Sprite
onready var animator : AnimationPlayer = $AnimationPlayer

var location : Vector2

enum DIRECTION { DOWN, LEFT, RIGHT, UP }
const anim_name = [ "walk_down", "walk_left", "walk_right", "walk_up" ]
const direction_vec = [Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP]
const _event_method_dict : Dictionary = {"direction_pressed":"input_direction","button_pressed":"pressed_button","button_released":"released_button"}

var moving_direction : int = -1
var looking_direction : int = DIRECTION.DOWN

onready var map : Node2D = get_parent()

func _process(_delta):
	if moving_direction >= 0 and moving_direction <= 3:
		set_look_direction(moving_direction)
		if map.is_open(location + direction_vec[moving_direction]):
			play_walk(moving_direction)
	elif (int(sprite.get_frame_coords().x) & 1 == 1):
		stop_walk()

func progress_walk():
	var coords = sprite.get_frame_coords()
	coords.x += 1
	if(coords.x >= sprite.hframes):
		coords.x = 0
	sprite.set_frame_coords(coords)

func set_look_direction(new_direction : int):
	if not looking_direction == new_direction:
		sprite.set_frame_coords(Vector2(0, new_direction))
		looking_direction = new_direction

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
	moving_direction = direction

func set_grid_position(direction_move: int):
	location = location + direction_vec[direction_move]
	get_parent().update_position(self, location)

func pressed_button(button_id):
	match button_id:
		JOY_XBOX_B:
			animator.set_speed_scale(2.0)
		JOY_R2, JOY_START:
			reset_states()
			var gm = get_tree().root.get_node("GameMaster")
			if gm != null and gm.has_method("exit_overworld_player"):
				gm.exit_overworld_player()
		JOY_XBOX_A:
			var interact_location = location + direction_vec[looking_direction]
			if map.has_method("interact"):
				map.interact(int(interact_location.x), int(interact_location.y))

func reset_states():
	animator.set_speed_scale(1.0)
	moving_direction = -1

func released_button(button_id):
	if button_id == JOY_XBOX_B:
		animator.set_speed_scale(1.0)

func focus():
	$Sprite/Camera2D.make_current()

func get_event_handler_method(event:String) -> String:
	return _event_method_dict[event]

func has_event_handler_method(event : String) -> bool:
	return _event_method_dict.has(event)
