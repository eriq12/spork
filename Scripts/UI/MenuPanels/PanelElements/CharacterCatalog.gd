extends ItemList

class_name CharacterCatalog

# to put an extra option
export(String) var option_name : String

export(Color) var party_color : Color
export(Color) var default_color : Color

var viewing : bool = false

var selected : int = -1

# to hold the current characters
var characters : Array

# to hold whether you have control of character
var player_controls : Array

# sets the character control, character_array is the list of characters to add to list
# control is the list of associated players for each characer
# player_id is the current player to filter against
func set_characters(character_array : Array, control : Array, player_id : int):
    # clear
    clear()
    # set characters
    characters = character_array
    # add characters to item list
    for index in range(characters.size()):
        var player_control = control[index]
        add_item(characters[index].name, null, player_control == player_id or player_control == -1)
        # and add new color if player controls character
        set_item_custom_bg_color(index, party_color if player_control == player_id else default_color)
    # add option if there is one
    if has_extra_option():
        add_item(option_name)
        set_item_custom_bg_color(get_item_count()-1, default_color)
    # reselect
    if viewing:
        if _is_selected_in_list():
            select(selected)
        elif get_item_count() > 0:
            select(0)
            selected = 0

# sets the coresponding color and disables unaccessible
# disables when number at an index does not match filter or is -1
# sets to alternate color (party_color) when number at index matches filter
func set_control(control : Array, filter : int):
    player_controls = control
    for index in range(characters.size()):
        match(control[index]):
            filter:
                set_item_disabled(index, false)
                set_item_custom_bg_color(index, party_color)
            -1:
                set_item_disabled(index, false)
                set_item_custom_bg_color(index, default_color)
            _:
                set_item_disabled(index, true)

func move_selection_up():
    # setup start at selction - 1 or at end of item list otherwise
    var new_selection = selected - 1
    # while selection is within borders and the item cannot be selected, continue up
    while new_selection > -1 and is_item_disabled(new_selection):
        new_selection -= 1
    # if still valid selection, then select
    if new_selection > -1:
        select(new_selection)
        selected = new_selection

func move_selection_down():
    # start setup at selected + 1 ( don't need to worry about -1 as it becomes 0 )
    var new_selection = selected + 1
    var item_count = get_item_count()
    # while in item list and item cannot be selected, continue down
    while new_selection < item_count and is_item_disabled(new_selection):
        new_selection += 1
    # if valid selection, then select
    if new_selection < item_count:
        select(new_selection)
        selected = new_selection

func view():
    viewing = true
    # check if there is a selected item
    if not _is_selected_in_list():
        # if there exists an option, get it
        if get_item_count() > 0:
            selected = -1
            move_selection_down()
        else:
            return
    # try selecting item
    if not is_item_disabled(selected):
        select(selected)
        return
    # if not, then try going down
    move_selection_down()
    # finally try going up
    if is_item_disabled(selected):
        move_selection_up()

func unview():
    viewing = false
    # check if there is a selected item, then unselect item
    if selected != -1:
        unselect(selected)

func _is_selected_in_list():
    return selected > -1 and selected < get_item_count()

func _is_selected_in_characters():
    return selected > -1 and selected < characters.size()

func get_selected_index() -> int:
    if selected >= characters.size():
        return -1
    return selected

func get_selected_character() -> CharacterData:
    if not _is_selected_in_characters():
        return null
    return characters[selected]

func is_extra_option_selected() -> bool:
    return has_extra_option() and _is_selected_in_list() and get_item_text(selected) == option_name

func has_extra_option() -> bool:
    return bool(option_name)