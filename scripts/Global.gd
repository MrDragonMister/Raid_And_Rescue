extends Node

@onready var enemy_spawn_pos: Vector3 = Vector3.ZERO
@onready var amount_of_enemies: int = 0
@onready var gold: int = 0
@onready var should_play_miss: bool = true
var level : int = 1

func get_angle_to(from, target) -> float:
	#Get the location of the target as a Vector2 from a top-down perspective
	var from_2d_position := Vector2(from.position.x, from.position.z)
	
	#Same thing as above. They both need to have the same origin.
	var target_2d_position := Vector2(target.position.x, target.position.z)
	
	#Vector from self/from to enemy on a top-down plane
	var relative_target_direction: Vector2 = (from_2d_position - target_2d_position).normalized()
	
	#Forward direction of self/from
	var forward_3d_direction: Vector3 = from.global_transform.basis.z
	var forward_2d_direction := Vector2(forward_3d_direction.x, forward_3d_direction.z).normalized()
	
	#Get angle to target
	var angle_to_target = abs(forward_2d_direction.angle_to(relative_target_direction))
	return angle_to_target

var item = {
	0: {
		"Name": "Sword",
		"Desc": "This is a sword!",
		"Cost": 10,
	},
	1: {
		"Name": "Axe",
		"Desc": "This is an axe!",
		"Cost": 10,
	},
	2: {
		"Name": "Bow",
		"Desc": "This is a bow!",
		"Cost": 10,
	},
}

func next_level():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	level += 1
