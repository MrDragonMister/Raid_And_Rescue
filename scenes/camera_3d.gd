extends Camera3D

@onready var Axe = $"../Axe"
@onready var Bow = $"../Bow"



func _process(delta):
	Axe.rotation.x += 0.01
	Bow.rotation.x += 0.01
