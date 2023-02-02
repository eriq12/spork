extends Control

onready var menu_panel : TabContainer = $MenuDialogue/PlayerMenuUI
onready var panel_dialogues : Array = menu_panel.get_children()
onready var game_master : GameMaster = get_tree().root.get_node("GameMaster")
var player_id : int
const _event_method_dict : Dictionary = {"direction_pressed":"pressed_direction","button_pressed":"pressed_button"}

var panel_unlocked : bool = true

func _ready():
	$MenuDialogue.visible = false

func pressed_direction(direction_id):
	var current_panel = panel_dialogues[menu_panel.current_tab]
	if current_panel is BaseMenuPanel or current_panel.has_method():
		current_panel.direction_pressed(direction_id)

func pressed_button(button_id):
	var amt_tabs = menu_panel.get_tab_count()
	var new_tab = menu_panel.current_tab
	match button_id:
		JOY_L:
			new_tab = (amt_tabs + menu_panel.current_tab - 1) % amt_tabs
		JOY_R:
			new_tab = (menu_panel.current_tab + 1) % amt_tabs
		JOY_R2, JOY_START:
			if game_master != null:
				game_master.set_controller_to_player(player_id)
		JOY_XBOX_A:
			print("Interact!")
		_:
			print("button pressed!")
	if panel_unlocked:
		menu_panel.current_tab = new_tab

func lock():
	menu_panel.set_tabs_visible(false)
	panel_unlocked = false

func unlock():
	panel_unlocked = true
	menu_panel.set_tabs_visible(true)

func get_event_handler_method(event:String) -> String:
	return _event_method_dict[event]

func has_event_handler_method(event : String) -> bool:
	return _event_method_dict.has(event)

func set_menu_active(state : bool):
	$MenuDialogue.visible = state
