extends Node

class_name ControllerHandler

enum DIRECTION {DOWN, LEFT, RIGHT, UP}

var device : int = -1

var player : int = -1
var device_name : String
var active : bool = false

signal button_pressed(button_id)
signal button_released(button_id)

signal direction_pressed(direction_id)

signal player_connection_changed(player_id)

var last_direction : int = -1

var x : float = 0
var y : float = 0
var activation_zone : float = 0.7

const button_ids = [JOY_XBOX_A, JOY_XBOX_B, JOY_XBOX_X, JOY_XBOX_Y, JOY_START, JOY_SELECT, JOY_R, JOY_L, JOY_DPAD_DOWN, JOY_DPAD_LEFT, JOY_DPAD_RIGHT, JOY_DPAD_UP]

func _unhandled_input(event):
	# if this handler has claimed a device
	if device != -1:
		# and the event is what is claimed
		if device == event.device:
			# handle joypad buttons
			if event is InputEventJoypadButton:
				match event.button_index:
					# directionals
					JOY_DPAD_UP, JOY_DPAD_DOWN, JOY_DPAD_LEFT, JOY_DPAD_RIGHT:
						var event_direction = (event.button_index - 9)%4
						if event_direction == last_direction:
							emit_signal("direction_pressed", -1)
							last_direction = -1
						elif event.pressed:
							emit_signal("direction_pressed", event_direction)
							last_direction = event_direction
					# other buttons to let other end to handle
					_:
						emit_signal("button_pressed" if event.pressed else "button_released", event.button_index)
			# TODO: implement joystick events
			get_tree().set_input_as_handled()
	# to handle accepting other 
	elif event is InputEventJoypadButton and event.button_index == JOY_XBOX_A:
		set_device(event.device)
		active = true
		emit_signal("player_connection_changed", player)
		get_tree().set_input_as_handled()

# sets the device and device name
func set_device(new_device : int):
	device_name = Input.get_joy_name(new_device)
	device = new_device
	print("Player %d is set to device %s" % [player, device_name])

# removes set device and name
func disable_device():
	device_name = ""
	device = -1

func player_active() -> bool:
	return device != -1

# sets player id in coresponding array (in gamemaster object)
func set_player_id(id):
	player = id

# gets player id
func get_player_id() -> int:
	return player

# a to string method
func _to_string() -> String:
	return "Player %d on device %s" % [device, device_name]
