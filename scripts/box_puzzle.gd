extends Node3D

func _ready() -> void:
	$button_3d.push_result = Callable(func() -> void:
		if check_slots():
			if not $door2.is_open:
				$door2.open()
				$button_3d/win.play()
		else:
			$button_3d/fail.play()
			$incorrect.show()
			await get_tree().create_timer(1.0).timeout
			$incorrect.hide())

func check_slots() -> bool:
	for i in $slots.get_children():
		if !i.correct_box:
			return false
	return true
