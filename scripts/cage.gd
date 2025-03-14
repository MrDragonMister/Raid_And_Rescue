extends StaticBody3D

@onready var start_y = position.y
@onready var should_be_lifted: bool = false
@onready var speed = Vector3.ZERO

func _ready():
	visible = true
	print("should be lifted: ", should_be_lifted)
	print("pos: ", position)
	print("start_y: ", start_y)

func _on_villager_freed():
	should_be_lifted = true
	print(should_be_lifted)

func _physics_process(delta):
	if should_be_lifted and position.y < start_y + 2.5:
		speed.y = delta
	if position.y >= start_y + 2.5:
		visible = false
		speed.y = 0
		# position.y = move_toward(start_y, start_y + 5, delta)
		
	move_and_collide(speed)
