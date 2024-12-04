extends RigidBody2D

@export var speed = 500000  # Bullet speed
@onready var sprite = $Sprite

var time_alive = 0.0  # Define the time_alive variable

func _ready():
	# Set the bullet's direction based on the player's rotation
	var direction = Vector2.RIGHT.rotated(rotation).normalized()
	# Apply an impulse to give it an initial speed in the desired direction
	apply_impulse(Vector2.ZERO, direction * speed)
	
func _process(delta):
	# Optional: You can limit the lifetime of the bullet to prevent it from going off-screen forever
	# (for example, destroy it after 2 seconds)
	time_alive += delta
	if time_alive > 2:
		queue_free()
