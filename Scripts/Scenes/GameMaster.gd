extends Node

class_name GameMaster

### variables

# handlers and events
enum CONTROL_STATE {NONE=-1, PLAYER=0, MENU=1}
var controller_control_state : Array = []
var controller_handlers : Array = []
var character_control : Array = []
const events = ["direction_pressed","button_pressed","button_released"]
const save_file_name = "user://savegame.save"

# overworld map
export(PackedScene) var default_scene
var map_asset : PackedScene
var map : LevelTemplate
var player_avatar : Player = null
var player_controller : int = -1

# player data
onready var party_data = $PartyData

# UI
var user_menu_ui : Array = []

### methods

func _ready():
	if not load_data():
		load_map(default_scene)
	
	# add all PlayerMenuUI
	for child in $Control.get_children():
		var player_menu = child.get_node("PlayerMenuUI")
		player_menu.player_id = user_menu_ui.size()
		user_menu_ui.push_back(player_menu)
	
	# add the handlers under party data to an array to keep track
	for child in $PartyData.get_children():
		controller_handlers.push_front(child)
		character_control.push_front(-1)
	
	for i in range(controller_handlers.size()):
		controller_handlers[i].set_player_id(i)
		controller_handlers[i].connect("player_connection_changed", self, "controller_active_toggle")
		controller_control_state.push_back(CONTROL_STATE.NONE)

# load data, returns true if data exists, false if no data file exists
func load_data() -> bool:
	var save_game = File.new()
	# if file does not exist return failure, else read file
	if not save_game.file_exists(save_file_name):
		return false
	save_game.open(save_file_name, File.READ)
	# get map data
	var map_data = parse_json(save_game.get_line())
	if map_data == null:
		return false
	load_map(map_data.get("map_asset", default_scene), map_data.get("x", 0), map_data.get("y",0), map_data.get("look_direction", 0))
	# clear player data
	party_data.clear_character_catalog()
	# load player data
	while save_game.get_position() < save_game.get_len():
		# get player data
		var player_data = parse_json(save_game.get_line())
		var new_player := CharacterData.new()
		new_player.load_data(player_data)
		# add to party
		party_data.add_new_character(new_player)
	# close file
	save_game.close()
	return true

# save data
func save_data():
	var save_game = File.new()
	save_game.open(save_file_name, File.WRITE)
	save_game.store_line(to_json(save_map()))
	# get player data
	var characters = party_data.get_character_catalog()
	# for each one in catalog, write to save file
	for c in characters:
		save_game.store_line(to_json(c.save_data()))
	save_game.close()

# saves relevant map data
func save_map() -> Dictionary:
	var location = player_avatar.get_grid_position()
	var x : int = int(location.x)
	var y : int = int(location.y)
	var save_dict = {
		"map_asset" : map_asset.get_path(),
		"x" : x,
		"y" : y,
		"look_direction" : player_avatar.get_look_direction()
	}
	return save_dict

# loads map (along with removing the current one should there be one in play)
func load_map(scene_source, x : int = 0, y : int = 0, look_direction : int = 0):
	if scene_source is String:
		scene_source = load(scene_source)
	if scene_source != map_asset:
		var temp_player_controller = player_controller
		if map != null:
			unload_map()
		# load overworld maps
		map = scene_source.instance()
		add_child(map)
		player_avatar = map.get_player()
		# if player had control, shift back
		if temp_player_controller != -1:
			set_controller_to_player(temp_player_controller)
		# remember map source
		map_asset = scene_source
	# set proper position for player
	player_avatar.set_grid_position(Vector2(x, y))
	player_avatar.set_look_direction(look_direction)

# removes map from play (and kicks players to their menu)
func unload_map():
	# unpair player form map if they are on
	exit_overworld_player()
	# unload existing map if exists
	if map != null:
		player_avatar = null
		map.queue_free()
		map = null
		map_asset = null


# removes player from overworld control (if there exists one)
func exit_overworld_player():
	if player_controller != -1:
		set_controller_to_menu(player_controller)

# sets player to control overworld
func set_controller_to_player(controller_handler_id : int):
	var controller_handler : ControllerHandler = controller_handlers[controller_handler_id]
	if player_controller == -1 or player_controller == controller_handler.get_player_id():
		player_controller = controller_handler.get_player_id()
		set_controller_target(controller_handler, player_avatar)
		controller_control_state[controller_handler_id] = CONTROL_STATE.PLAYER
		user_menu_ui[controller_handler_id].set_menu_active(false)

# sets player to control menu
func set_controller_to_menu(controller_handler_id : int, temporary_control : bool = false):
	var ui_menu = user_menu_ui[controller_handler_id]
	var controller_handler : ControllerHandler = controller_handlers[controller_handler_id]
	set_controller_target(controller_handler, ui_menu)
	controller_control_state[controller_handler_id] = CONTROL_STATE.MENU
	user_menu_ui[controller_handler_id].set_menu_active(true)
	if player_controller == controller_handler_id and not temporary_control:
		player_controller = -1

# sets the controller to handle the current map's player entity
func set_controller_target(controller_handler : ControllerHandler, target):
	if target == null:
		return
	for event in events:
		clear_connections(controller_handler, event)
		if target.has_event_handler_method(event):
			assert (controller_handler.connect(event, target, target.get_event_handler_method(event)) == 0, "ERROR: connect failed")

# removes connections for events listed in events constant
func clear_connections(node:Node, signal_name:String):
	var connections = node.get_signal_connection_list(signal_name)
	for conn in connections:
		node.disconnect(conn.signal, conn.target, conn.method)

# toggles controller being active and accepting information and none at all
# (should be called when a controller_handler accepts a device)
func controller_active_toggle(player_id : int):
	if controller_control_state[player_id] == CONTROL_STATE.NONE:
		# enable controller and give control to menu
		set_controller_to_menu(player_id)
	else:
		# disable controller menu and return to none
		var controller_handler = controller_handlers[player_id]
		for event in events:
			clear_connections(controller_handler, event)
		controller_control_state[player_id] = CONTROL_STATE.NONE

func prompt_overworld_player(prompt : Control):
	# get player menu
	var menu = user_menu_ui[player_controller]
	# change control to menu
	set_controller_to_menu(player_controller, true)
	menu.prompt_user(prompt)
	# wait for user to acknowledge
	yield(menu, "prompt_acknowledged")
	set_controller_to_player(player_controller)
