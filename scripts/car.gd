class_name Car extends AnimatableBody3D

static var reset_point : Vector3
static var grandpa : Node3D

func _physics_process(delta: float) -> void:
	position.x += 90 * delta


func _on_car_exlpode_timeout() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Bean:
		$impact.play(0.15)
		get_parent().get_parent().switcharoo()
		body.fade_out()
		body.global_position = reset_point
		body.rotation = Vector3.ZERO
		body.velocity = Vector3.ZERO
