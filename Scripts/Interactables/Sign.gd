extends InteractibleTile

signal prompt(prompt_text)

export var text : String

func interact() -> bool:
	emit_signal("prompt", text)
	return true
