extends Node

@onready var target_pos = Vector3()
@onready var player_pos = Vector3.ZERO
@onready var enemy_spawn_pos = Vector3.ZERO
@onready var amount_of_enemies = 1

func set_target(new_target_pos):
	target_pos = new_target_pos

func set_player_pos(new_player_pos):
	player_pos = new_player_pos

func set_enemy_spawn_pos(new_enemy_spawn_pos):
	enemy_spawn_pos = new_enemy_spawn_pos
	
func change_amount_of_enemies(change):
	amount_of_enemies += change
