extends Control

@export var select_character_button_group: ButtonGroup
@export var select_level_button_group: ButtonGroup


func _on_start_button_pressed():
	var chosen_character = select_character_button_group.get_pressed_button()
	var chosen_level = select_level_button_group.get_pressed_button()
	Global.chosen_character = chosen_character.text
	Global.chosen_level = chosen_level.text
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
