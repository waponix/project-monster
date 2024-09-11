extends CharacterBody3D
class_name Monster

@export var awareness_distance: float
@export var health: float
@export var movement_speed: float

var player: Player

var attributes: Dictionary
var damage: Damage
