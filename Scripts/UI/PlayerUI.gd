extends Control

onready var menu_panel : TabContainer = $MenuDialogue/PlayerMenuUI
onready var panel_dialogues : Array = menu_panel.get_children()
var game_master : GameMaster
var player_id : int
const _event_method_dict : Dictionary = {"direction_pressed":"pressed_direction","button_pressed":"pressed_button"}

func _ready():
	$MenuDialogue.visible = false

func pressed_direction(direction_id):
	panel_dialogues[menu_panel.current_tab].direction_pressed(direction_id)

func pressed_button(button_id):
	var amt_tabs = menu_panel.get_child_count()
	match button_id:
		JOY_L:
			menu_panel.current_tab = (menu_panel.get_tab_count() + menu_panel.current_tab - 1) % amt_tabs
		JOY_R:
			menu_panel.current_tab = (menu_panel.current_tab + 1) % amt_tabs
		JOY_XBOX_A:
			print("Interact!")
		_:
			print("button pressed!")

func get_event_handler_method(event:String) -> String:
	return _event_method_dict[event]

func has_event_handler_method(event : String) -> bool:
	return _event_method_dict.has(event)

func set_menu_active(state : bool):
	$MenuDialogue.visible = state
