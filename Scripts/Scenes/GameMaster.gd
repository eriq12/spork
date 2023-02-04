extends Node

class_name GameMaster

### variables

# handlers and events
enum CONTROL_STATE {NONE=-1, PLAYER=0, MENU=1}
var controller_control_state : Array = []
var controller_handlers : Array = []
var character_control : Array = []
const events = ["direction_pressed","button_pressed","button_released"]


# overworld map
export var default_scene : String = ""
var map : LevelTemplate
var location : Vector2
var player_avatar : Entity = null
var player_controller : int = -1

# UI
var user_menu_ui : Array = []

### methods

func _ready():
	load_map(default_scene)
	
	# add all PlayerMenuUI
	for child in $Control.get_children():
		user_menu_ui.push_back(child.get_node("PlayerMenuUI"))
	
	# add the handlers under party data to an array to keep track
	for child in $PartyData.get_children():
		controller_handlers.push_front(child)
		character_control.push_front(-1)
	
	for i in range(controller_handlers.size()):
		controller_handlers[i].set_player_id(i)
		controller_handlers[i].connect("player_connection_changed", self, "controller_active_toggle")
		controller_control_state.push_back(CONTROL_STATE.NONE)

# loads map (along with removing the current one should there be one in play)
func load_map(scene_source : String):
	if map != null:
		unload_map()
	# load overworld maps
	map = load(scene_source).instance()
	add_child(map)
	player_avatar = map.get_player()

# removes map from play (and kicks players to their menu)
func unload_map():
	# unpair player form map if they are on
	exit_overworld_player()
	# unload existing map if exists
	if map != null:
		player_avatar = null
		map.queue_free()
		map = null

# removes player from overworld control (if there exists one)
func exit_overworld_player():
	if player_controller != -1:
		set_controller_to_menu(player_controller)

# OLD CODE: swaps control between menu and overworld should you not know the current state of player
func swap_control(player_id):
	match controller_control_state[player_id]:
		# swap to player or no change if player already taken
		CONTROL_STATE.MENU:
			if set_controller_to_player(player_id):
				print("Changed control of player %d to control overworld sprite." % player_id)
		# swap to menu
		_:
			print("Changing control of player %d to their menu" % player_id)
			set_controller_to_menu(player_id)
		
# sets player to control overworld
func set_controller_to_player(controller_handler_id : int) -> bool:
	var controller_handler : ControllerHandler = controller_handlers[controller_handler_id]
	if player_controller == -1 or player_controller == controller_handler.get_player_id():
		player_controller = controller_handler.get_player_id()
		set_controller_target(controller_handler, player_avatar)
		controller_control_state[controller_handler_id] = CONTROL_STATE.PLAYER
		user_menu_ui[controller_handler_id].set_menu_active(false)
		return true
	return false

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
