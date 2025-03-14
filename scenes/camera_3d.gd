extends Camera3D

@onready var Sword = $"../Sword"
@onready var Axe = $"../Axe"
@onready var Bow = $"../Bow"



func _process(_delta):
	Sword.rotation.z += 0.01
	Axe.rotation.x += 0.01
	Bow.rotation.x += 0.01
