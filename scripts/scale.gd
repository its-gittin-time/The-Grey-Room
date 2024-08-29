extends Node3D

@onready var anim := $"AnimationPlayer"
@onready var right_area := $"Armature_012/Skeleton3D/Torus_011/Torus_011/right_area"
@onready var left_area := $"Armature_012/Skeleton3D/Torus_012/left_area"
var right_weight := 0
var left_weight := 0
var final_time := 0.0

func _ready() -> void:
	anim.play("tilt")
	#anim.seek(2.1667, true)
	#anim.pause()

func _process(_delta: float) -> void:
	#if anim.is_playing():
		#print(anim.current_animation_position," ",anim.get_playing_speed())

	if anim.get_playing_speed() > 0 and anim.is_playing():
		if anim.current_animation_position > final_time:
			anim.pause()
	else:
		if anim.current_animation_position < final_time:
			anim.pause()

	right_weight = 0
	left_weight = 0
	for body : Node3D in right_area.get_overlapping_bodies():
		if body.is_in_group("box"):
			right_weight += body.weight
	for body : Node3D in left_area.get_overlapping_bodies():
		if body.is_in_group("box"):
			left_weight += body.weight
	if right_weight > left_weight:
		play_to_target_time(1.1333)
	elif right_weight < left_weight:
		#anim.play("tilt")
		play_to_target_time(3.2)
	elif right_weight == left_weight:
		play_to_target_time(2.1667)
	#print(right_area.get_overlapping_bodies(),right_weight,left_weight)

func play_to_target_time(time: float) -> void:
	final_time = time
	if anim.current_animation_position < time:
		anim.play("tilt")
	else:
		anim.play_backwards("tilt")
