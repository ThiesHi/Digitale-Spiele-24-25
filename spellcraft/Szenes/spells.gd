extends Area2D

@export var initial_speed = 800
@export var deceleration = 1

var velocity = Vector2.ZERO
var time_alive = 0.0

func _ready():
	var direction = Vector2.RIGHT.rotated(rotation).normalized()  # Get the direction the player is facing
	velocity = direction * initial_speed
	
func _process(delta):
	velocity = velocity.lerp(Vector2.ZERO, deceleration * delta)
	position += velocity * delta
	time_alive += delta
	if time_alive > 2:
		queue_free()
