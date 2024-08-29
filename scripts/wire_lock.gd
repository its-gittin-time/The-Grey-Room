extends Area3D

@export var slot_number : int
var current_wire : Wire

func _on_area_entered(area: Area3D) -> void:
	if area.get_parent() is Wire and not current_wire:
			area.get_parent().super_point = $marker_3d.global_position - area.get_parent().global_position
			current_wire = area.get_parent()

func _on_area_exited(area: Area3D) -> void:
	if current_wire == area.get_parent():
			area.get_parent().super_point = Vector3.ZERO
			current_wire = null

func correct_wire() -> bool:
	if current_wire:
		if current_wire.target_slot == slot_number:
			return true
	return false
