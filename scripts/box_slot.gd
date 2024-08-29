extends Node3D

@export var colour : String
@export_range(0, 20, 1) var desired_weight : int
@onready var prefix := colour + " pad:\n"
@onready var area := $area_3d
@onready var label := $label_3d
var correct_box := false

func _process(_delta: float) -> void:
	var box_count := 0
	for body : Node3D in area.get_overlapping_bodies():
		if body.is_in_group("box"):
			box_count += 1
	if box_count > 1:
		label.text = prefix + "Too many boxes inserted"
	elif box_count <= 0:
		label.text = prefix + "No box inserted"
	elif box_count == 1:
		label.text = prefix + "Box inserted"
		for body : Node3D in area.get_overlapping_bodies():
			if body.is_in_group("box"):
				if body.weight == desired_weight:
					correct_box = true
					return
	correct_box = false
