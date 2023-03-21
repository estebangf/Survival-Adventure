extends TileMap

func _ready():
	self.set_layer_enabled(3, true)

func _on_houses_body_exited(body):
	self.set_layer_enabled(3, true)
func _on_houses_body_entered(body):
	self.set_layer_enabled(3, false)
