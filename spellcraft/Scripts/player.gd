extends CharacterBody2D

const max_speed = 400
const accel = 1500
const friction = 2700 

@onready var sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node
@export var spell_scene: PackedScene  # spell scene to spawn
@onready var spells = preload("res://Szenes/spell.tscn")  # Bullet scene
@onready var cooldownTimer = $CooldownTimer
var can_use_ability: bool = true

var input = Vector2.ZERO

func _ready():
	# Ensure bullet scene is assigned
	if spell_scene == null:
		push_error("spells scene is not assigned!")

func _physics_process(delta: float) -> void:
	player_movement(delta)
	update_animation(delta)
	if Input.is_action_just_pressed("CAST") and can_use_ability:  # "shoot" is the action you set up in the input map
		shoot_spell()

func get_input():
	input.x = int(Input.is_action_pressed("RIGHT")) - int(Input.is_action_pressed("LEFT"))
	input.y = int(Input.is_action_pressed("DOWN")) - int(Input.is_action_pressed("UP"))
	return input.normalized()

func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO: 
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else: 
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
	
	move_and_slide()

func update_animation(delta): 
	var input = get_input() 
	if input == Vector2.RIGHT:
		sprite.frame = int(Time.get_ticks_msec()/200)%2+1 
	elif input == Vector2.LEFT:
		sprite.frame = int(Time.get_ticks_msec()/200)%2+1 
	elif input == Vector2.DOWN:
		sprite.frame = int(Time.get_ticks_msec()/200)%2+1 
	elif input == Vector2.UP:
		sprite.frame = int(Time.get_ticks_msec()/200)%2+1 
	elif input == Vector2(1,-1):
		sprite.frame=int(Time.get_ticks_msec()/200)%2+5 
	elif input == Vector2(-1,-1):
		sprite.frame=int(Time.get_ticks_msec()/200)%2+6 
	elif input == Vector2(1,1):
		sprite.frame = int(Time.get_ticks_msec()/200)%2+7 
	elif input == Vector2(-1,1):
		sprite.frame = int(Time.get_ticks_msec()/200)%2+8 
	else: sprite.frame = 0

func shoot_spell():
	var spells = spells.instantiate()  # Create an instance of the spells
	spells.position = position + Vector2(10, 0)
	get_parent().add_child(spells)  # Add the spells to the scene
	use_ability()
	 
func use_ability():
	if can_use_ability:
		can_use_ability = false
		var timer := Timer.new()
		add_child(timer)
		timer.wait_time = 2.0
		timer.one_shot = true
		timer.start()
	else:
		print("Ability on cooldown!")
		
func _on_CooldownTimer_timeout():
	can_use_ability = true  # Reset cooldown state
	print("Cooldown finished!")
