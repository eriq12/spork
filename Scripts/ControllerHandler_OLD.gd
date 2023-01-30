extends Node2D

export var device : int = 1

export var activation_threshold : float = 0.8

# output controller input
var _input : int = -1

enum BUTTON { DOWN, LEFT, RIGHT, UP, A, B, X, Y, START, SELECT, R, L, R2, L2, INVALID = -1}
const BUTTON_NAMES = ["DOWN", "LEFT", "RIGHT", "UP", "A", "B", "X", "Y", "START", "SELECT", "R", "L", "R2", "L2"]

export var DEBUG : bool = true

func _ready():
	if DEBUG:
		if device < Input.get_connected_joypads().size():
			print(Input.get_joy_name(device))

func _process (_delta):
	if device > -1 and device < Input.get_connected_joypads().size():
		var output = joypad_input(device, activation_threshold)
		_input = output
		if DEBUG and output > -1:
			print("Device %d : %s" % [device, BUTTON_NAMES[output]])

func get_input() -> int:
	return _input

static func joypad_input(device_id : int, activation_threshold: float) -> int:
	var vertical_axis : float = Input.get_joy_axis(device_id,1)
	var horizontal_axis : float = Input.get_joy_axis(device_id,0)
	var vertical_greater_than_horizontal : bool = abs(vertical_axis) > abs(horizontal_axis)
	var major_axis = vertical_axis if vertical_greater_than_horizontal else horizontal_axis
	if (abs(major_axis) > activation_threshold):
		if vertical_greater_than_horizontal:
			return BUTTON.DOWN if major_axis > 0 else BUTTON.UP
		else:
			return BUTTON.RIGHT if major_axis > 0 else BUTTON.LEFT
	return -1
