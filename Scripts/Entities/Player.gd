extends Entity

class_name Player

const _event_method_dict : Dictionary = {"direction_pressed":"input_direction","button_pressed":"pressed_button","button_released":"released_button"}

# handles button presses for overworld player entity
func pressed_button(button_id):
	match button_id:
		JOY_XBOX_B:
			animator.set_speed_scale(2.0)
		JOY_R2, JOY_START:
			reset_states()
			if game_master != null and game_master.has_method("exit_overworld_player"):
				game_master.exit_overworld_player()
		JOY_XBOX_A:
			var interact_location = location + direction_vec[_looking_direction]
			if game_master.has_method("interact"):
				game_master.interact(int(interact_location.x), int(interact_location.y))

# handles button release
func released_button(button_id):
	if button_id == JOY_XBOX_B:
		animator.set_speed_scale(1.0)

# accessor for associated method name for given event name
func get_event_handler_method(event:String) -> String:
	return _event_method_dict[event]

# accessor to find if class has 
func has_event_handler_method(event : String) -> bool:
	return _event_method_dict.has(event)
