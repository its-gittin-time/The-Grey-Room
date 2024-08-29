extends Node

const main_menu = preload("res://scenes/main_menu.tscn")
var bean : Bean
var preserved_rotation : Vector3
var preserved_position : Vector3
var preserved_cam_tilt := 0.0
func _ready() -> void:
	if OS.has_feature("editor"):
		get_tree().root.mode = Window.MODE_WINDOWED
		get_tree().root.size = Vector2i(1280,720)
		get_tree().root.move_to_center()
	get_tree().root.min_size = Vector2i(640,360)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen") and OS.get_name() != "Web":
		if get_tree().root.mode != Window.MODE_EXCLUSIVE_FULLSCREEN:
			get_tree().root.mode = Window.MODE_EXCLUSIVE_FULLSCREEN
		else:
			get_tree().root.mode = Window.MODE_MAXIMIZED

const NORMAL_VISION = Basis(
	Vector3(1.0,0.0,0.0),
	Vector3(0.0,1.0,0.0),
	Vector3(0.0,0.0,1.0))
const PROTANOPIA = Basis(
	Vector3(0.152286,1.052583,-0.204868),
	Vector3(0.114503,0.786281,0.099216),
	Vector3(-0.003882, -0.048116,1.051998))
const DEUTERANOPIA = Basis(
	Vector3(0.367322,0.860646,-0.227968),
	Vector3(0.280085,0.672501,0.047413),
	Vector3(-0.011820,0.042940,0.968881))
const TRITANOPIA = Basis(
	Vector3(1.255528,-0.076749,-0.178779),
	Vector3(-0.078411,0.930809,0.147602),
	Vector3(0.004733,0.691367,0.303900))
