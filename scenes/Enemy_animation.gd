extends AnimationPlayer

@onready var enemy = $"../.."

func _process(_delta: float) -> void:
	if enemy.velocity.length() > 2:
		play("Walking")
	else:
		stop()
		
func attack():
	play("ArmatureAction")
