extends State

class_name MonsterSeek

@onready var vision: Vision = $"../../Vision"
@onready var navigation: NavigationAgent3D = $"../../Navigation"
@onready var look_left: Node3D = $"../../LookLeft"
@onready var look_right: Node3D = $"../../LookRight"

var target_position: Vector3
var movement_speed: float
var wander_timer: float
var wander_duration: float
var player_position: Vector3

func randomize_wander(position: Vector3 = Vector3.ZERO, timer: float = 0):
	target_position = position
	wander_timer = timer
	
	if position == Vector3.ZERO:
		wander_timer = randf_range(0.5, 0.8)
		var wander_distance: float = randf_range(2, 5)
		target_position = body.position + (wander_distance * target_position.normalized())
		
		var positions: Array = [
			look_left.global_position,
			look_right.global_position,
			target_position,
		]
		
		var index := randi_range(0, 2)
		
		target_position = positions[index]
	else:
		wander_duration = 10

func enter():
	print('entered seek state')
	vision.saw_something.connect(on_saw_something)
	movement_speed = body.movement_speed
	wander_duration = 6
	#get_player_halfed_position()
	#randomize_wander(player_position, 1)
	randomize_wander()
	
func update(delta: float):
	if wander_duration > 0:
		wander_duration -= delta
		
	if wander_timer > 0:
		wander_timer -= delta
	

func physics_update(delta: float):
	if wander_duration <= 0:
		state_changed.emit(self, 'MonsterIdleBasic')
		
	if wander_timer > 0:
		return
		
	navigation.target_position = target_position
		
	var direction := navigation.get_next_path_position() - body.global_position
	direction = direction.normalized()
	
	body.velocity = direction * movement_speed
	
	body.move_and_slide()

func on_saw_something(node: Node3D):
	if not active:
		return
		
	if node is Player:
		body.player = node
		state_changed.emit(self, 'MonsterChase')


func _on_navigation_navigation_finished() -> void:
	if not active:
		return
		
	randomize_wander()
	
func get_player_halfed_position() -> void:
	player_position = (body.player.global_position + body.position) / 2


func _on_awareness_body_entered(node: Node3D) -> void:
	if not active:
		return

	if node is Player and node.velocity != Vector3.ZERO:
		randomize_wander(node.global_position, 0.5)
		
func get_attention(monster: Monster, range: float):
	if not active:
		return
	
	if monster.name != body.name and monster.global_position.distance_to(body.global_position) <= range:
		print('got attention while seeking!', body.name)
		randomize_wander(monster.global_position, 0)
