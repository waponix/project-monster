extends Node3D
class_name Attraction

@onready var main_body: Monster
@onready var state_machine: StateMachine = $"../StateMachine"
@export var call_interval: float = 3
@export var range: float = 10

var call_timer: float

func _ready() -> void:
	main_body = get_parent()
	call_timer = call_interval

func _process(delta: float) -> void:
	if call_timer > 0:
		call_timer -= delta
	
	if call_timer <= 0 and state_machine.current_state is MonsterChase:
		for monster in get_tree().get_nodes_in_group('Monsters'):
			var state_machine: StateMachine = monster.get_node('StateMachine')	
		
			if state_machine.current_state is MonsterIdleBasic or state_machine.current_state is MonsterSeek:
				state_machine.current_state.get_attention(main_body, range)
		
	if call_timer <= 0:
		call_timer = call_interval
		
