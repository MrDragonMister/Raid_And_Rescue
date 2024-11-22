extends Marker3D

func _physics_process(delta):
	Global.set_target(position)
