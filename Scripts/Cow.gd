extends CharacterBody2D

enum COW_STATE { IDLE, WLAKING }

const SPEED = 20.0

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var time = $Timer

@export var move_direction: Vector2 = Vector2.ZERO
@export var current_state: COW_STATE = COW_STATE.IDLE
@export var idle_time = 5
@export var walk_time = 2


func _ready():
	pick_new_state()
	
func _physics_process(_delta):
	if(current_state == COW_STATE.WLAKING):
		velocity = move_direction * SPEED
		
		move_and_slide()
	
func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)

	animation_tree.set("parameters/Walk/blend_position", move_direction.x)
	animation_tree.set("parameters/Idle/blend_position", move_direction.x)
	
func pick_new_state():
	var decicion = randi_range(0,2)
	if(decicion != 0):
		state_machine.travel("Walk")
		current_state = COW_STATE.WLAKING
		select_new_direction()
		time.start(randi_range(1,2))
	else:
		state_machine.travel("Idle")
		current_state = COW_STATE.IDLE
		time.start(randi_range(1,5))


func _on_timer_timeout():
	pick_new_state()
	
func touched(body):
	print("muuuuuuu!!")
	state_machine.travel("Idle")
	current_state = COW_STATE.IDLE
	time.start(5)
	body.touched(3)
