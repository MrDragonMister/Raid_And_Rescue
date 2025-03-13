extends Panel

var selectslot = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Label.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1:
			$Label2.release_focus()
			$Label3.release_focus()
			$Label.grab_focus()
			selectslot = 1
		elif event.keycode == KEY_2:
			$Label.release_focus()
			$Label3.release_focus()
			$Label2.grab_focus()
			selectslot = 2
		elif event.keycode == KEY_3:
			$Label.release_focus()
			$Label2.release_focus()
			$Label3.grab_focus()
			selectslot = 3

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			selectslot = 3 if selectslot == 1 else selectslot - 1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			selectslot = 1 if selectslot == 3 else selectslot + 1
		
		# Focus wisselen na scrollen
		_update_focus()

func _update_focus():
	# Focus correct zetten op basis van `selectslot`
	if selectslot == 1:
		$Label2.release_focus()
		$Label3.release_focus()
		$Label.grab_focus()
	elif selectslot == 2:
		$Label.release_focus()
		$Label3.release_focus()
		$Label2.grab_focus()
	elif selectslot == 3:
		$Label.release_focus()
		$Label2.release_focus()
		$Label3.grab_focus()
		
