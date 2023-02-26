extends Node

var character_catalog : Array = [] setget , get_character_catalog
var player_controls : Array = [] setget , get_player_controls

signal control_change
signal roster_change

# get the list of all characters
func get_character_catalog() -> Array:
    return Array(character_catalog)

# remove all characters from catalog, along with removing connections
func clear_character_catalog():
    for _index in range(character_catalog.size()):
        var character = character_catalog.pop_back()
        if character.has_method("clear_connections"):
            character.clear_connections()

# accessor for player's party 
func get_player_party(player_index : int) -> Array:
    var player_party := []
    for i in range(player_controls.size()):
        if player_controls[i] == player_index:
            player_party.append(character_catalog[i])
    return player_party

func get_full_party() -> Array:
    var player_party := []
    for i in range(player_controls.size()):
        if player_controls[i] != -1:
            player_party.append(character_catalog[i])
    return player_party

# gets the amount of characters in control
func get_number_characters_selected() -> int:
    var total : int = 0
    for character in player_controls:
        if character != -1:
            total+=1
    return total

# returns whether player has control over character (defaults with player_index -1)
func has_player_control(character_index : int, player_index : int = -1) -> bool:
    return player_controls[character_index] == player_index

func get_player_controls() -> Array:
    return Array(player_controls)

# gets if there is a full combined party
func is_full_party() -> bool:
    var remaining := 4
    for character in player_controls:
        if character != -1:
            remaining -= 1
            if remaining == 0:
                return true
    return false

# sets control for a character
func update_control(player_index : int, character_index : int, assuming_control : bool = true):
    # bool to find whether the player requesting to assume control is allowed to or not
    var available_to_control : bool = has_player_control(character_index, player_index) or has_player_control(character_index)
    # can never take control of another character if the party is full
    # so long as that is not the case and you are able to change control for the character, it should go through
    if not(is_full_party() and assuming_control) and available_to_control:
        player_controls[character_index] = player_index if assuming_control else -1
        emit_signal("control_change")
    
# creates new character, and sets control of that new character if there is room in party
func add_new_character(new_character : CharacterData, control : int = -1):
    character_catalog.append(new_character)
    player_controls.append(control if not is_full_party() else -1)
    emit_signal("roster_change")