extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_button_button_up() -> void:
	get_tree().change_scene_to_packed(preload("res://scenes/main_menu.tscn"))
