extends Node2D

export var device : int = -1

var direction_map_names = []

enum DIRECTION {DOWN, LEFT, RIGHT, UP}
const direction_map_name_bases = ["down", "left", "right", "up"]
const direction_axis_ids = [JOY_AXIS_1, JOY_AXIS_0, JOY_AXIS_0, JOY_AXIS_1]
const direction_map_flip = [false, true, false, true]
const direction_button_ids = [JOY_DPAD_DOWN, JOY_DPAD_LEFT, JOY_DPAD_RIGHT, JOY_DPAD_UP]

var button_map_names = []

const button_map_name_bases = ["a", "b", "x", "y", "start", "select", "l", "l2", "r", "r2"]
const button_map_ids = [JOY_XBOX_A, JOY_XBOX_B, JOY_XBOX_X, JOY_XBOX_Y, JOY_START, JOY_SELECT, JOY_L, JOY_L2, JOY_R, JOY_R2]

func _ready():
	set_process(false)
	
func _process(_delta):
	var direction = Input.get_vector(direction_map_names[DIRECTION.LEFT], direction_map_names[DIRECTION.RIGHT], direction_map_names[DIRECTION.DOWN], direction_map_names[DIRECTION.UP])
	if(not direction == Vector2.ZERO):
		print(direction)

func set_device(new_device : int):
	device = new_device
	create_map(new_device)
	print(direction_map_names)
	print("Mappings created, starting process")
	set_process(true)

func create_map(device_num : int) -> bool:
	# check for if this set of controls exists, if so then get out, we already have it
	if(InputMap.has_action("%s_%d" % [direction_map_name_bases[0], device_num])):
		return false
	var temp_motion_action_event: InputEventJoypadMotion
	var temp_button_action_event: InputEventJoypadButton
	for i in range(0, direction_map_name_bases.size()):
		# action name
		var new_action_name : String = "%s_%d" % [direction_map_name_bases[i], device_num]
		direction_map_names.append(new_action_name)
		InputMap.add_action(new_action_name)
		# motion event ( axis )
		temp_motion_action_event = InputEventJoypadMotion.new()
		temp_motion_action_event.device = device_num
		temp_motion_action_event.axis = direction_axis_ids[i]
		temp_motion_action_event.axis_value = -1 if direction_map_flip[i] else 1
		InputMap.action_add_event(new_action_name, temp_motion_action_event)
		# button event ( well, button )
		temp_button_action_event = InputEventJoypadButton.new()
		temp_button_action_event.button_index = direction_button_ids[i]
		temp_button_action_event.device = device_num
		temp_button_action_event.pressed = true
		InputMap.action_add_event(new_action_name, temp_button_action_event)
	return true


static func remove_map(device_num : int):
	pass
