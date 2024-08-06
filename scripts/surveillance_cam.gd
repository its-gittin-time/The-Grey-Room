class_name SurveillanceCamera extends Node3D

static var bean : Bean

func _process(_delta: float) -> void:
	var pos_vec2 := Vector2(position.x, position.z)
	var bean_vec2 := Vector2(bean.position.x, bean.position.z)
	var angle := pos_vec2.angle_to(bean_vec2)
	print(rad_to_deg(angle), pos_vec2, bean_vec2)
	rotation.y = angle * 3.0#angle#lerp(rotation.y, angle, delta * 10.0)
	#var new_pos = lerp()
	look_at(Vector3(bean.position.x, position.y, bean.position.z))
