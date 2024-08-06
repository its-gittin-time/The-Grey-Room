extends Control

func _ready() -> void:
	if OS.get_name() == "Web":
		$quite.hide()

func _on_start_button_up() -> void:
	get_tree().change_scene_to_packed(preload("res://scenes/test.tscn"))


func _on_quit_button_up() -> void:
	get_tree().quit()


# how long until ashton finds this lol - sam o
# 15 Minutes
