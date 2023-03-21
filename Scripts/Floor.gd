extends StaticBody2D

var state_floor = 0
var max_state_flor = 2
var state_plant = 0
var max_state_plant = 4
@onready var time = $Timer

func _ready():
	$SpritePlant.visible = false

func _physics_process(delta):
		$SpriteFloor.frame = state_floor
		$SpritePlant.frame = state_plant
	

func touched(body):
	if(state_plant < max_state_plant):
		print("Touched floor")
		state_floor = minf(state_floor+1, max_state_flor)
		if(time.is_stopped()):
			time.start(5)
	body.touched(0.5)


func _on_timer_timeout():
	print("Touched floor timeout")
	state_floor -= 1
	state_plant = minf(state_plant+1, max_state_plant)
	$SpritePlant.visible = true
	if(state_floor == 0):
		time.stop()	
