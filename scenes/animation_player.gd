extends AnimationPlayer

@onready var enemy = $"../.."

func _process(delta: float) -> void:
#	if is_zero_approx(enemy.velocity.length()):
#		print("walk")
	play("Walking")
#	else:
#		print("stop")
