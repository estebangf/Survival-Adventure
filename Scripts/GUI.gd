extends CanvasLayer

@onready var tool_sprite = $Interface/ToolSprite

func _on_player_tool_changed(tool_number):
	tool_sprite.frame = tool_sprite.hframes * tool_number * 2
