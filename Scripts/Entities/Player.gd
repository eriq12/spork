extends Entity

class_name Player

const _event_method_dict : Dictionary = {"direction_pressed":"input_direction","button_pressed":"pressed_button","button_released":"released_button"}

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
			var interact_location = location + direction_vec[_looking_direction]
			if map.has_method("interact"):
				map.interact(int(interact_location.x), int(interact_location.y))

func released_button(button_id):
    if button_id == JOY_XBOX_B:
        animator.set_speed_scale(1.0)

func get_event_handler_method(event:String) -> String:
    return _event_method_dict[event]

func has_event_handler_method(event : String) -> bool:
    return _event_method_dict.has(event)