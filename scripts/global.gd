extends Node

@onready var target_pos = Vector3()
@onready var player_pos = Vector3.ZERO

func set_target(new_target_pos):
	target_pos = new_target_pos

func set_player_pos(new_player_pos):
	player_pos = new_player_pos
