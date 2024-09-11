extends Monster

@export var fall_acceleration = 75.0
@export var turn_speed: float  = 10

@onready var vision: Vision = $Vision
@onready var awareness: Area3D = $Awareness

var target_velocity = Vector3.ZERO

func _ready() -> void:
	add_to_group('Monsters')
	
func _physics_process(delta: float) -> void:
	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	velocity.y = target_velocity.y
	
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), delta * turn_speed)
