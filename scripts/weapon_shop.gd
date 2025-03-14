extends CanvasLayer

var CurrentItem = 0
#var select = 0
@onready var Sword = $Control/Icon2/Sword
@onready var Axe = $Control/Icon2/Axe
@onready var Bow = $Control/Icon2/Bow
@onready var gold = $"../gamegui/PanelContainer/MarginContainer/GridContainer/gold"
@onready var Click = $"../Click"


func _ready():
	get_node("Control/Icon2/" + str(Global.items[CurrentItem]["Name"])).visible = true
	get_node("Control/Name").text = Global.items[CurrentItem]["Name"]
	get_node("Control/Desc").text = Global.items[CurrentItem]["Desc"]
	get_node("Control/UpgradeInfo").text = "Level: " + str(Global.inventory[CurrentItem]["Level"]) + "->" + str(Global.inventory[CurrentItem]["Level"]+ 1) + "\nCost: " + str(Global.items[CurrentItem]["Cost"])

func _on_close_pressed() -> void:
	Click.play()
	get_node("Anim").play("TransOut")
	print("transout")

func SwitchItem(select):
	for i in range(Global.items.size()):
		if select == i:
			Sword.visible = false
			Axe.visible = false
			Bow.visible = false
			CurrentItem = select
			get_node("Control/Name").text = Global.items[CurrentItem]["Name"]
			get_node("Control/Desc").text = Global.items[CurrentItem]["Desc"]
			get_node("Control/UpgradeInfo").text = "Level: " + str(Global.inventory[CurrentItem]["Level"]) + "->" + str(Global.inventory[CurrentItem]["Level"]+ 1) + "\nCost: " + str(Global.items[CurrentItem]["Cost"])
			get_node("Control/Icon2/" + str(Global.items[CurrentItem]["Name"])).visible = true

func _on_buy_pressed() -> void:
	Click.play()
	if Global.gold >= Global.items[CurrentItem]["Cost"]:
		gold.change_coins(-Global.items[CurrentItem]["Cost"])
		Global.inventory[CurrentItem]["Level"] += 1
		print(Global.inventory[CurrentItem]["Level"])
		Global.items[CurrentItem]["Cost"] += 5
	else:
		print("not enough gold")
	SwitchItem(CurrentItem)


func _on_select_sword_pressed() -> void:
	Click.play()
	SwitchItem(0)
func _on_select_axe_pressed() -> void:
	Click.play()
	SwitchItem(1)
func _on_select_bow_pressed() -> void:
	Click.play()
	SwitchItem(2)
