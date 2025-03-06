extends AnimationPlayer

@onready var enemy = $"../.."

func _process(_delta: float) -> void:
	if not is_playing() and enemy.velocity.length() > 2:
		play("Walking")

func attack():
	stop()
	play("ArmatureAction")
