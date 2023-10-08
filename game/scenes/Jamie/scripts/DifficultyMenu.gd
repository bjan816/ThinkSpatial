extends Control
class_name DifficultyMenu

@onready var menu : = $MiroMenu
@onready var page1 : = $InstructionPage1
@onready var page2 : = $InstructionPage2
@onready var page3 : = $InstructionPage3

func _on_about_pressed():
	menu.hide()
	page1.show()


func _on_instruction_page_1_gui_input(event):
	if event is InputEventMouseButton:
		page1.hide()
		page2.show()


func _on_instruction_page_2_gui_input(event):
	if event is InputEventMouseButton:
		page2.hide()
		page3.show()


func _on_instruction_page_3_gui_input(event):
	if event is InputEventMouseButton:
		page3.hide()
		menu.show()
