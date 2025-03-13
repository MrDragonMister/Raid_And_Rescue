extends CanvasLayer

var CurrentItem = 0
var select = 0

func _on_close_pressed() -> void:
	get_node("Anim").play("TransOut")
	print("transout")

func SwitchItem(select):
	for i in range(Global.items.size()):
		if select == i:
			CurrentItem = select
			print(Global.items[CurrentItem])

func _on_buy_pressed() -> void:
	pass
