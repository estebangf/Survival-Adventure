extends TileMap

func _ready():
	self.set_layer_enabled(3, true)

func _on_houses_body_exited(body):
	if(body.name == "Player"):
		self.set_layer_enabled(3, true)
func _on_houses_body_entered(body):
	if(body.name == "Player"):
		self.set_layer_enabled(3, false)
