extends AnimationPlayer

@onready var enemy = $"../.."
@onready var player = $world_objects/Player

func _process(_delta: float) -> void:
	if enemy.velocity.length() > 2:
		play("Walking")
	else:
		stop()
func attack(player_pos):
	if enemy.attack_ready and enemy.nav.target_position == player_pos and enemy.nav.distance_to_target() <= enemy.ENEMY_WEAPON_FORWARD_RANGE:
		play("ArmatureAction")
		print("im dead")
