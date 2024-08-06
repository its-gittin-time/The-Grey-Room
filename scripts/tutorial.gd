extends Node3D

func _ready() -> void:
	$buttoneeee_3d.push_result = Callable(func():
		create_tween().tween_property($door, "position:y", 3.8, 3).set_trans(Tween.TRANS_QUAD))
