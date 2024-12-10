extends AnimationPlayer

@onready var enemy = $"../.."

func _process(delta: float) -> void:
	if enemy.velocity.length() > 2:
		play("Walking")
	else:
		stop()
