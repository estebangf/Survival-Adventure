extends CharacterBody2D

const JUMP_VELOCITY = -200.0

@export var SPEED: float = 100.0
@export var starting_position: Vector2 = Vector2(0,1)

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var handle_zone = $HandZone/Hand
@onready var timer = $Timer

var body_in_hand_zone = null

var touching = false

func _ready():
	update_animation_parameters(starting_position)

func _physics_process(delta):
	if(touching == false):
		var input_direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		update_animation_parameters(input_direction)
		
		velocity = input_direction * SPEED

		move_and_slide()
		pick_new_state()
		
		if(Input.is_key_pressed(KEY_SPACE)):
			touch()
	
func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		
func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
		
		
func _on_hand_zone_body_entered(body):
	print(body.name)
	if(body.name != "TileMap" && body.name != "Player"):
		body_in_hand_zone = body

func touch():
	if(body_in_hand_zone != null):
		touching = true
		if(body_in_hand_zone.has_method("touched")):
			body_in_hand_zone.touched(self)
		else:
			timer.start(0.25)
			print("No pasó nada al tocarlo...")

func touched(time):
	timer.start(time)
	
func _on_hand_zone_body_exited(body):
	body_in_hand_zone = null

func _on_timer_timeout():
	if(touching == true):
		touching = false



func _on_area_2d_body_entered(body):
	pass # Replace with function body.
