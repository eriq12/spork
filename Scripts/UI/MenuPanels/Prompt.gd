extends BaseMenuPanel

class_name PromptPanel

signal acknowledged()

signal close_panel()

func interact():
	# signal that prompt has been acknowledged
	emit_signal("acknowledged")
	emit_signal("close_panel")

func set_prompt(new_prompt : String):
	$Label.text = new_prompt
