extends Node3D
class_name LineOfSight

var raycasts: Array = []
var view_distance: float = 0.0

signal break_sight

func _ready() -> void:
	for child in get_children():
		if child is RayCast3D:
			raycasts.push_back(child)


func _physics_process(delta: float) -> void:
	for raycast in raycasts:
		raycast.target_position.z = view_distance
		if raycast.is_colliding():
			var node = raycast.get_collider()
			if node is not Player:
				break_sight.emit()
