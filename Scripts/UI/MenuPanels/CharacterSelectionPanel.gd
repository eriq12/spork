extends BaseMenuPanel

var party_data
var player_id : int = -1
onready var character_catalog : CharacterCatalog = $CharacterCatalog
onready var player_party : CharacterCatalog = $PlayerParty
var selected_catalog : CharacterCatalog
enum Direction {DOWN, LEFT, RIGHT, UP}

func _ready():
	party_data = get_tree().root.get_node("GameMaster/PartyData")
	party_data.connect("roster_change", self, "update_character_roster")
	party_data.connect("control_change", self, "update_player_control")
	selected_catalog = character_catalog

func direction_pressed(direction_id : int):
	match direction_id:
		# if not in player party and right, swap to party
		Direction.RIGHT:
			if selected_catalog != player_party:
				set_mode(true)
		# else if not in character catalog and left, swap to 
		Direction.LEFT:
			if selected_catalog != character_catalog:
				set_mode(false)
		# otherwise just go up and down
		Direction.UP:
			if selected_catalog != null:
				selected_catalog.move_selection_up()
		Direction.DOWN:
			if selected_catalog != null:
				selected_catalog.move_selection_down()

func update():
	update_character_roster()
	update_player_control()
	if selected_catalog != null:
		selected_catalog.view()

func update_character_roster():
	# get new player catalog
	var catalog = party_data.get_character_catalog()
	# get control
	var player_control = party_data.get_player_control()
	# update character catalog
	character_catalog.set_characters(catalog, player_control, player_id)

func update_player_control():
	var player_control = party_data.get_player_control()
	character_catalog.set_control(player_control, player_id)

func set_mode(to_party : bool):
	selected_catalog.unview()
	selected_catalog = player_party if to_party else character_catalog
	selected_catalog.view()

func set_player_id(id : int):
	player_id = id

func interact():
	# if in character catalog
	if selected_catalog == character_catalog:
		# if selected option to get new character, then create a new one
		if selected_catalog.is_extra_option_selected():
			party_data.add_new_character(CharacterData.new())
		else:
			var char_index = selected_catalog.get_selected_index()
			party_data.update_control(player_id, char_index)

