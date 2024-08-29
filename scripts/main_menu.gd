extends Control

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if OS.get_name() == "Web":
		%quit.hide()
	if OS.has_feature("editor"):
		$audio_stream_player.volume_db = -80

func _on_start_button_up() -> void:
	get_tree().change_scene_to_packed(preload("res://scenes/level_1.tscn"))

func _on_quit_button_up() -> void:
	get_tree().quit()

func _on_credits_button_up() -> void:
	%initial.hide()
	%credits_screen.show()

func _on_credits_return_button_up() -> void:
	%credits_screen.hide()
	%initial.show()
