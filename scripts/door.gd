extends AnimatableBody3D

@export var already_open := false
var is_open := false

func _ready() -> void:
	if already_open:
		open()

func open() -> void:
	$door_anim.play("open")
	is_open = true

func close() -> void:
	$door_anim.play("close")
	is_open = false
