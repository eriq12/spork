extends Node

var character_catalog : Array = [] setget , get_character_catalog
var player_control : Array = [] setget , get_player_control

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
    for i in range(player_control.size()):
        if player_control[i] == player_index:
            player_party.append(character_catalog[i])
    return player_party

# gets the amount of characters in control
func get_number_characters_selected() -> int:
    var total : int = 0
    for character in player_control:
        if character != -1:
            total+=1
    return total

func get_player_control() -> Array:
    return Array(player_control)

# gets if there is a full combined party
func is_full_party() -> bool:
    var remaining := 4
    for character in player_control:
        if character != -1:
            remaining -= 1
            if remaining == 0:
                return true
    return false

# sets control for a character
func update_control(player_index : int, character_index : int):
    # TODO: Take into account party size (aka undo mistake of ignoring it)
    if player_control[character_index] == -1 or player_control[character_index] == player_index:
        player_control[character_index] = player_index if player_control[character_index] == -1 else -1
        emit_signal("control_change")

func add_new_character(new_character : CharacterData, control : int = -1):
    character_catalog.append(new_character)
    player_control.append(control)
    emit_signal("roster_change")