extends Node
class_name State

@onready var body: CharacterBody3D
var active: bool = false

signal state_changed	
	
func exit():
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	pass
