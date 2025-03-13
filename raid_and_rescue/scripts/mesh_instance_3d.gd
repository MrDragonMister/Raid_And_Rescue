extends MeshInstance3D

@onready var player = $".."

func _process(_delta):
		visible = player.active_camera == player.camera2
