extends Node

@onready var target_pos = Vector3()
@onready var player_pos = Vector3.ZERO
@onready var enemy_spawnpos = Vector3(0, 1, 0)


func set_target(new_target_pos):
	target_pos = new_target_pos

func set_player_pos(new_player_pos):
	player_pos = new_player_pos

func set_enemy_spawnpos(position):
	enemy_spawnpos = position
