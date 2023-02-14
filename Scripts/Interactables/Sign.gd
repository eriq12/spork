extends InteractibleTile

export var text : String

func _ready():
	var panel : PromptPanel = $Prompt
	panel.set_prompt(text)
	_set_panel(panel)
	self.remove_child(panel)
	