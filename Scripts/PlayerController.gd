extends CharacterBody2D

signal tool_changed(tool_number)

@export var SPEED: float = 100.0
@export var starting_position: Vector2 = Vector2(0,1)

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var state_machine_working = animation_tree.get("parameters/Working/playback")
@onready var handle_zone = $HandZone/Hand
@onready var timer = $Timer

var body_in_hand_zone = null

enum PLAYER_STATE {
	IDLE,
	WALKING,
	TOUCHING,
	WORKING,
	WAITING
}

var player_state = PLAYER_STATE.IDLE
var selected_tool = 0

func _ready():
	update_animation_parameters(starting_position)

func _physics_process(delta):
	if(player_state != PLAYER_STATE.WAITING and player_state != PLAYER_STATE.WORKING):
		var input_direction = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		update_animation_parameters(input_direction)
		
		velocity = input_direction * SPEED
		if(velocity != Vector2.ZERO):
			player_state = PLAYER_STATE.WALKING
		else:
			player_state = PLAYER_STATE.IDLE

		
		if(Input.is_key_pressed(KEY_SPACE)):
			touch()
		if(Input.is_key_pressed(KEY_Z)):
			change_tool()

		move_and_slide()
	pick_new_state_and_animation()
	
func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/Work/blend_position", move_input)
		animation_tree.set("parameters/Working/Water/blend_position", move_input)
		animation_tree.set("parameters/Working/Axe/blend_position", move_input)
		animation_tree.set("parameters/Working/Hoe/blend_position", move_input)

		
func pick_new_state_and_animation():
	match player_state:
		PLAYER_STATE.TOUCHING:
			print("TOUCHING")
			player_state = PLAYER_STATE.WORKING
		PLAYER_STATE.WORKING:
			print("WORKING")
			state_machine.travel("Working")
			match selected_tool:
				0: state_machine_working.travel("Water")
				1: state_machine_working.travel("Axe")
				2: state_machine_working.travel("Hoe")
		PLAYER_STATE.WALKING:
			print("WALKING")
			state_machine.travel("Walk")
		PLAYER_STATE.IDLE:
			print("IDLE")
			state_machine.travel("Idle")				
	

func touch():
	if(body_in_hand_zone != null):
		player_state = PLAYER_STATE.TOUCHING
		if(body_in_hand_zone.has_method("touched")):
			body_in_hand_zone.touched(self, selected_tool)
		else:
			timer.start(0.25)
			print("No pasó nada al tocarlo...")

func touched(time):
	timer.start(time)
	
	
func _on_hand_zone_body_entered(body):
	print(body.name)
	if(body.name != "TileMap" && body.name != "Player"):
		body_in_hand_zone = body
		
func _on_hand_zone_body_exited(body):
	body_in_hand_zone = null

func _on_timer_timeout():
	if(player_state != PLAYER_STATE.IDLE):
		player_state = PLAYER_STATE.IDLE

func change_tool():
	match selected_tool:
		2: selected_tool = 0
		_: selected_tool = min(selected_tool + 1, 2)
	emit_signal("tool_changed",selected_tool)
	player_state = PLAYER_STATE.WAITING
	touched(0.25)
