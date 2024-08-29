class_name SurveillanceCamera extends Node3D

static var bean : Bean
@onready var armature := $"sec camera fixed uv/Armature_013"
@onready var my_pos := Vector2(armature.global_position.x,armature.global_position.z)

func _process(delta: float) -> void:
	if not bean: return
	var pos := Vector2(bean.global_position.x, bean.global_position.z)
	var new_vec := pos - my_pos
	#print(my_pos, pos)
	#print(new_vec, rad_to_deg(new_vec.angle()))
	var angle := PI + new_vec.angle()
#	print(rad_to_deg(angle))
	if angle <= deg_to_rad(10) or angle >= deg_to_rad(170):
		if angle >= deg_to_rad(270) or angle < deg_to_rad(10):
			angle = deg_to_rad(10)
		else:
			angle = deg_to_rad(170)
#	print(rad_to_deg(angle))
	armature.global_rotation.y = lerp_angle( armature.global_rotation.y, (3.0*PI/2.0) - angle, delta * 0.75)#(3.0*PI/2.0) - clampf(PI + new_vec.angle(), deg_to_rad(10), deg_to_rad(170))
	#armature.global_rotation.y = clampf((PI/2) - new_vec.angle(), deg_to_rad(100), deg_to_rad(260))#clampf(new_vec.angle(), deg_to_rad(100), deg_to_rad(260))
	#print(my_pos, pos, new_vec)
	#print(rad_to_deg( PI + new_vec.angle() ))
	#print( (PI/2.0) - new_vec.angle() )
	#print( (3.0*PI/2.0) - (PI + new_vec.angle()) )
#	print(PI + new_vec.angle())
	#print(armature.global_rotation_degrees.y, " ", rad_to_deg(PI + new_vec.angle()), " ", rad_to_deg(new_vec.angle()))
	#armature.rotation_degrees.z = 180
	armature.rotation_degrees.x = 18
	#print(armature.rotation_degrees.y)
	#armature.rotation_degrees.y = clamp(armature.rotation_degrees.y, 100, 180)
