extends StaticBody2D

@onready var time = $Timer

enum STATE_FLOR {
	NOT_WATER,
	WITH_WATER,
	WITH_MORE_WATER
}
enum STATE_PLANT {
	NOT_PLANT,
	INITIAL,
	MINIMAL,
	CRECIDA,
	FINAL
}

var state_flor: STATE_FLOR = STATE_FLOR.NOT_WATER
var state_plant: STATE_PLANT = STATE_PLANT.NOT_PLANT

func _physics_process(delta):
		$SpriteFloor.frame = get_state_floor_number()
		$SpritePlant.frame = get_state_plant_number()
		$SpritePlant.visible = state_plant != STATE_PLANT.NOT_PLANT

func touched(body, tool):
	if(tool == 0):
		match state_flor:
			STATE_FLOR.NOT_WATER: state_flor = STATE_FLOR.WITH_WATER
			STATE_FLOR.WITH_WATER: state_flor = STATE_FLOR.WITH_MORE_WATER
	else:
		state_flor = STATE_FLOR.NOT_WATER
		state_plant = STATE_PLANT.NOT_PLANT
	if(time.is_stopped()):
		time.start(5)
	body.touched(0.5)


func _on_timer_timeout():
	print("Touched floor timeout")
	if(state_flor != STATE_FLOR.NOT_WATER):
		match state_flor:
			STATE_FLOR.WITH_WATER: state_flor = STATE_FLOR.NOT_WATER
			STATE_FLOR.WITH_MORE_WATER: state_flor = STATE_FLOR.WITH_WATER
			
		match state_plant:
			STATE_PLANT.NOT_PLANT: state_plant = STATE_PLANT.INITIAL
			STATE_PLANT.INITIAL: state_plant = STATE_PLANT.MINIMAL
			STATE_PLANT.MINIMAL: state_plant = STATE_PLANT.CRECIDA
			STATE_PLANT.CRECIDA: state_plant = STATE_PLANT.FINAL
			
		if(state_flor == STATE_FLOR.NOT_WATER):
			time.stop()


func get_state_floor_number():
	match state_flor:
		STATE_FLOR.NOT_WATER: return 0
		STATE_FLOR.WITH_WATER: return 1
		STATE_FLOR.WITH_MORE_WATER: return 2
	
func get_state_plant_number():
	match state_plant:
		STATE_PLANT.NOT_PLANT: return 0
		STATE_PLANT.INITIAL: return 1
		STATE_PLANT.MINIMAL: return 2
		STATE_PLANT.CRECIDA: return 3
		STATE_PLANT.FINAL: return 4
