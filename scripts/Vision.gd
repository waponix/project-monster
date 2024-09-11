extends Node3D
class_name Vision

@export var view_distance: float
var raycasts: Array = []

signal saw_something

var seen_previously: Node3D

func _ready() -> void:
	
	for child in get_children():
		if child is RayCast3D:
			child.target_position.z = view_distance
			raycasts.push_back(child)


func _physics_process(delta: float) -> void:
	for raycast in raycasts:
		raycast.target_position.z = view_distance
			
		if raycast.is_colliding():
			var node = raycast.get_collider()
			
			if seen_previously == null or seen_previously.name != node.name:
				seen_previously = node
				saw_something.emit(node)
		elif seen_previously != null:
			seen_previously = null
