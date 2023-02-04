extends BaseMenuPanel

signal acknowledged()

func interact():
	# clear
	$Label.text = ""
	# signal that prompt has been acknowledged
	emit_signal("acknowledged")

func set_prompt(new_prompt : String):
	$Label.text = new_prompt
