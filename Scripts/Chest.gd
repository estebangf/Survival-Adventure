extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func touched(body):
	print("Abriendo cofre")
	$AnimationPlayer.play("open_chest")
	body.touched(1)
