extends ButtonMenuPanel

# prepares menu to be able to be interacted with
func _ready():
	_set_selected($GridContainer/Button)

# test to see which button was interacted with
func interact():
	print("Interact %s" % selected.text)