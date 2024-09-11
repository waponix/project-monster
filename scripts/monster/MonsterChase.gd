extends State
class_name MonsterChase

@export var vision: Vision

@onready var navigation: NavigationAgent3D = $"../../Navigation"

var distance_to_player: float
var max_distance:float = 20.0
var lost_sight: bool = false
var movement_speed: float

var player_position: Vector3

func enter():
	print('entered chase state')
	vision.saw_something.connect(_on_saw_something)
	navigation = body.get_node('Navigation')
	lost_sight = true
	movement_speed = body.movement_speed * 1.7
	get_player_position()
	
func physics_update(delta: float) -> void:
	navigation.target_position = player_position
	var direction := navigation.get_next_path_position() - body.global_position
	direction = direction.normalized()
	
	body.velocity = direction * movement_speed
	body.move_and_slide()
		

func get_player_position() -> void:
	player_position = body.player.global_position
	
func get_player_halfed_position() -> void:
	player_position = (body.player.global_position + body.position) / 2

func _on_navigation_navigation_finished() -> void:
	if not active:
		return
	
	if not lost_sight:
		# lost sight of player
		lost_sight = true
		
		#update the user last position
		get_player_halfed_position()
	else:
		state_changed.emit(self, 'MonsterSeek')
	
func _on_saw_something(node: Node3D) -> void:
	if not active:
		return
		
	if node is Player:
		lost_sight = false
		get_player_position()
