extends AnimatableBody3D

var down := false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body.name == "box" or body is Bean) and not down:
		$animation_player.play("move")
		down = true
		print("down")


func _on_area_3d_body_exited(body: Node3D) -> void:
	if (body.name == "box" or body is Bean) and down:
		$animation_player.play_backwards("move")
		down = false
		print("up")
