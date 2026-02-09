extends Control

@onready var upgrade_menu = $UpgradeMenu

func _ready():
	upgrade_menu.hide()

func _on_button_3_slots_pressed():
	test_ui(false)

func _on_button_5_slots_pressed():
	test_ui(true)

func test_ui(is_perfect: bool):
	upgrade_menu.show()
	upgrade_menu.open_upgrade_menu(is_perfect)
