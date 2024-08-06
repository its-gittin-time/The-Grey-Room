extends AnimatableBody3D

@export var already_open := false

func _ready() -> void:
	if already_open:
		$door_anim.play("open")

func open() -> void:
	$door_anim.play("open")

func close() -> void:
	$door_anim.play("close")
