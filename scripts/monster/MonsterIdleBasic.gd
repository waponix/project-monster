extends State

class_name MonsterIdleBasic

@onready var vision: Vision = $"../../Vision"
@onready var navigation: NavigationAgent3D = $"../../Navigation"

var target_position: Vector3
var movement_speed: float
var wander_timer: float

func randomize_wander(position: Vector3 = Vector3.ZERO, timer: float = 0):
	target_position = position
	wander_timer = timer
	movement_speed = body.movement_speed * 0.7
	
	if position == Vector3.ZERO:
		var wander_distance: float = randf_range(10, 30)
		target_position = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
		target_position = body.position + (wander_distance * target_position.normalized())		
		wander_timer = randi_range(0, 1)
		movement_speed = body.movement_speed * randf_range(0.5, 0.7)

func enter():
	print('entered idle state')
	vision.saw_something.connect(_on_saw_something)
	navigation = body.get_node('Navigation')
	randomize_wander()
	
func update(delta: float):
	if wander_timer > 0:
		wander_timer -= delta

func physics_update(delta: float):			
	if wander_timer > 0:
		return
		
	navigation.target_position = target_position
		
	var direction := navigation.get_next_path_position() - body.global_position
	direction = direction.normalized()
	
	body.velocity = direction * movement_speed
	
	body.move_and_slide()

func _on_saw_something(node: Node3D) -> void:
	if not active:
		return
		
	if node is Player:
		body.player = node
		state_changed.emit(self, 'MonsterChase')
		
func _on_navigation_navigation_finished() -> void:
	if not active:
		return
	randomize_wander()


func _on_awareness_body_entered(node: Node3D) -> void:
	if not active:
		return
		
	if node is Player and node.velocity != Vector3.ZERO:
		randomize_wander(node.global_position, 0.5)
		
func get_attention(monster: Monster, range: float):
	if not active:
		return
	
	if monster.name != body.name and monster.global_position.distance_to(body.global_position) <= range:
		print('got attention while idle!', body.name)
		randomize_wander(monster.global_position, 0)
