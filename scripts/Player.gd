extends CharacterBody3D

class_name Player

@export var movement_speed: float
@export var fall_acceleration = 75.0
var target_velocity = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	movement_controller(delta)
	
	
func movement_controller(delta: float) -> void:
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		direction.z += 1
	if Input.is_action_pressed("move_backward"):
		direction.z -= 1
	if Input.is_action_pressed("strafe_left"):
		direction.x += 1
	if Input.is_action_pressed("strafe_right"):
		direction.x -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		#basis = Basis.looking_at($Turn.basis)
		
	# Ground Velocity
	target_velocity.x = direction.x * movement_speed
	target_velocity.z = direction.z * movement_speed
	
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
		
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	
	
