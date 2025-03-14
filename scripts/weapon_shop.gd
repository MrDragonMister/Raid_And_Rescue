extends CanvasLayer

var CurrentItem = 0
#var select = 0
@onready var Axe = $Control/Icon2/Axe
@onready var Bow = $Control/Icon2/Bow

signal hide_weapons

func _ready():
#	Axe.visible = false
#	Bow.visible = false
#	get_node("Control/Icon2/" + str(Global.items[CurrentItem]["Name"])).visible = true
	get_node("Control/Name").text = Global.items[CurrentItem]["Name"]
	get_node("Control/Desc").text = Global.items[CurrentItem]["Desc"]
	get_node("Control/UpgradeInfo").text = "Cost:" + str(Global.items[CurrentItem]["Cost"])

func _on_close_pressed() -> void:
	get_node("Anim").play("TransOut")
	print("transout")

func SwitchItem(select):
	for i in range(Global.items.size()):
		if select == i:
			Axe.visible = false
			Bow.visible = false
			CurrentItem = select
			get_node("Control/Name").text = Global.items[CurrentItem]["Name"]
			get_node("Control/Desc").text = Global.items[CurrentItem]["Desc"]
			get_node("Control/UpgradeInfo").text = "Cost:" + str(Global.items[CurrentItem]["Cost"])
			get_node("Control/Icon2/" + str(Global.items[CurrentItem]["Name"])).visible = true

func _on_buy_pressed() -> void:
	pass


func _on_select_sword_pressed() -> void:
	SwitchItem(0)
func _on_select_axe_pressed() -> void:
	SwitchItem(1)
func _on_select_bow_pressed() -> void:
	SwitchItem(2)
