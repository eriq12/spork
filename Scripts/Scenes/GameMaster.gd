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
	# load overworld maps
	map = load(default_scene).instance()
	add_child(map)
	player_avatar = map.get_player()
	
	# add all PlayerMenuUI
	for child in $Control.get_children():
		user_menu_ui.push_back(child.get_node("PlayerMenuUI"))
	
	# add the handlers under party data to an array to keep track
	for child in $PartyData.get_children():
		controller_handlers.push_front(child)
		character_control.push_front(-1)
		child.connect("switch_control", self, "swap_control")
	
	for i in range(controller_handlers.size()):
		controller_handlers[i].set_player_id(i)
		controller_control_state.push_back(CONTROL_STATE.NONE)

# TODO: change control
func swap_control(player_id):
	match controller_control_state[player_id]:
		# TODO: swap to player or none if player already taken
		CONTROL_STATE.MENU:
			if set_controller_to_player(player_id):
				print("Changed control of player %d to control overworld sprite." % player_id)
				controller_control_state[player_id] = CONTROL_STATE.PLAYER
				user_menu_ui[player_id].set_menu_active(false)
		# TODO: swap to menu
		_:
			print("Changing control of player %d to their menu" % player_id)
			set_controller_to_menu(player_id)
			controller_control_state[player_id] = CONTROL_STATE.MENU
			user_menu_ui[player_id].set_menu_active(true)
		

func set_controller_to_player(controller_handler_id : int) -> bool:
	var controller_handler : ControllerHandler = controller_handlers[controller_handler_id]
	if player_controller == -1:
		player_controller = controller_handler.get_player_id()
		set_controller_target(controller_handler, player_avatar)
		return true
	return false

func set_controller_to_menu(controller_handler_id : int):
	var ui_menu = user_menu_ui[controller_handler_id]
	var controller_handler : ControllerHandler = controller_handlers[controller_handler_id]
	set_controller_target(controller_handler, ui_menu)
	if(player_controller == controller_handler_id):
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
