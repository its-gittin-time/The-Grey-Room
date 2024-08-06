class_name Interactable extends AnimatableBody3D

var behaviour : Callable

func interact() -> void:
	if behaviour:
		behaviour.call()
