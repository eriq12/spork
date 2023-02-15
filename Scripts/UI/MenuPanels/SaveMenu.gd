extends ButtonMenuPanel

# signals to save and load
signal save_data
signal load_data

# prepares menu to be able to be interacted with
func _ready():
    _set_selected(find_node("SaveButton"))

func interact():
    match selected.text:
        "Save":
            emit_signal("save_data")
        "Load":
            emit_signal("load_data")