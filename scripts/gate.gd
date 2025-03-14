extends Node3D

@onready var player: CharacterBody3D = $"../../Player"
@onready var game_manager : Node = $"../../../game_manager"


func _input(_event):
	if Input.is_action_just_pressed("interact") and (player.position - position).length() < 3:
		player.interacting = true
		if game_manager.is_vilager_free:
			if Global.level == 4:
				if Global.amount_of_alfred == 0:
					Global.next_level()
			else:
				Global.next_level()
		else:
			pass
			# pop-up "free the villager first
		player.interacting = false
