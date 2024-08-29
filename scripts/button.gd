class_name Button3D extends AnimatableBody3D

@export_range(0.0, 10.0, 0.05, "or_greater") var push_time := 0.25
@export_range(0.0, 10.0, 0.05, "or_greater") var push_distance := 0.1
@export_range(0.0, 10.0, 0.05, "or_greater") var push_hold := 0.0
@export var push_direction := Vector3(0.0, 0.0, 1.0)

@export_category("Easing")
@export var transistion_type : Tween.TransitionType = Tween.TRANS_QUAD
@export var ease_type : Tween.EaseType = Tween.EASE_OUT

var pushing := false
var push_result : Callable

func push() -> void:
	if pushing:
		return
	pushing = true
	var original_position := position
	var push_tween := create_tween()
	push_tween.set_trans(transistion_type).set_ease(ease_type)
	push_tween.tween_property(self, "position", original_position - (push_distance * push_direction), push_time)
	if push_result: push_tween.tween_callback(push_result)
	if push_hold: push_tween.tween_interval(push_hold)
	push_tween.tween_property(self, "position", original_position, push_time)
	await push_tween.finished
	pushing = false
