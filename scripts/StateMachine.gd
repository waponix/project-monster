extends Node
class_name StateMachine

@export var control_body: CharacterBody3D
@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	if initial_state:
		initial_state.body = control_body
		initial_state.active = true
		initial_state.enter()
		current_state = initial_state
		
	for child in get_children():
		if (child is State):
			child.state_changed.connect(on_state_changed)
			states[child.name.to_lower()] = child
	
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_state_changed(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	
	if !new_state:
		return
		
	if current_state:
		current_state.active = false
		current_state.exit()
		
	new_state.body = control_body
	new_state.active = true
	new_state.enter()

	current_state = new_state
