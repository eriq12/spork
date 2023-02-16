extends Control

onready var menu_panel : TabContainer = $MenuDialogue/PlayerMenuUI
onready var game_master : GameMaster 
var player_id : int
const _event_method_dict : Dictionary = {"direction_pressed":"pressed_direction","button_pressed":"pressed_button"}

signal prompt_acknowledged()

var panel_unlocked : bool = true

func _ready():
	$MenuDialogue.visible = false
	var save_menu = find_node("Save")
	game_master = get_tree().root.get_node("GameMaster")
	save_menu.connect("save_data", game_master, "save_data")
	save_menu.connect("load_data", game_master, "load_data")

func pressed_direction(direction_id):
	var current_panel = menu_panel.get_child(menu_panel.current_tab)
	if current_panel.has_method("direction_pressed"):
		current_panel.direction_pressed(direction_id)

func pressed_button(button_id):
	match button_id:
		JOY_L:
			shift_tab(false)
		JOY_R:
			shift_tab(true)
		JOY_R2, JOY_START, JOY_XBOX_B:
			if game_master != null and panel_unlocked:
				game_master.set_controller_to_player(player_id)
		JOY_XBOX_A:
			var current_panel = menu_panel.get_child(menu_panel.current_tab)
			if current_panel.has_method("interact"):
				current_panel.interact()

func shift_tab(go_right : bool):
	if not panel_unlocked:
		return
	var new_tab : int = menu_panel.current_tab + (1 if go_right else -1)
	if new_tab < 0:
		new_tab = menu_panel.get_tab_count() - 1
	elif new_tab >= menu_panel.get_tab_count():
		new_tab = 0
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

func prompt_user(prompt : Control):
	var current_tab : int = menu_panel.current_tab
	var prompt_tab_index = menu_panel.get_tab_count()
	menu_panel.add_child(prompt)
	lock()
	menu_panel.current_tab = prompt_tab_index
	yield(prompt, "close_panel")
	menu_panel.current_tab = current_tab
	unlock()
	menu_panel.remove_child(prompt)
	emit_signal("prompt_acknowledged")
