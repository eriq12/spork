extends BaseMenuPanel

var selected : Control

var selected_theme : StyleBoxFlat = preload("res://Assets/Themes/SelectedButton.tres")
var unselected_theme : StyleBoxFlat = preload("res://Assets/Themes/UnselectedButton.tres")

func _ready():
	_set_selected($GridContainer/Button)

func direction_pressed(direction_id : int):
	var new_selection : Control = null
	match direction_id:
		ControllerHandler.DIRECTION.UP:
			new_selection = selected.get_node(selected.get_focus_neighbour(MARGIN_TOP))
		ControllerHandler.DIRECTION.DOWN:
			new_selection = selected.get_node(selected.get_focus_neighbour(MARGIN_BOTTOM))
		ControllerHandler.DIRECTION.LEFT:
			new_selection = selected.get_node(selected.get_focus_neighbour(MARGIN_LEFT))
		ControllerHandler.DIRECTION.RIGHT:
			new_selection = selected.get_node(selected.get_focus_neighbour(MARGIN_RIGHT))
	if new_selection != null:
		_set_selected(new_selection)

func interact():
	print("Interact %s" % selected.text)

func _set_selected(new_selection : Control):
	var temp : Control = selected
	if temp != null:
		# TODO: unselect temp appearance
		temp.add_stylebox_override("normal", unselected_theme)
	selected = new_selection
	# TODO: select temp appearance
	selected.add_stylebox_override("normal", selected_theme)
