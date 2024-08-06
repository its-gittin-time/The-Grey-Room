extends Node3D

@onready var area := $area_3d
@onready var label := $label_3d

func _process(delta: float) -> void:
	var box_count := 0
	for body in area.get_overlapping_bodies():
		if body.is_in_group("box"):
			box_count += 1
	if box_count > 1:
		label.text = "Too many boxes inserted"
	elif box_count == 1:
		label.text = "Box inserted"
	elif box_count <= 0:
		label.text = "No box inserted"
