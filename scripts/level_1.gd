extends Node3D

const fog_material = preload("res://materials/fog.tres")

func _ready() -> void:
	if OS.get_name() == "Windows":
		$world_environment.environment.volumetric_fog_enabled = true
		$world_environment.environment.volumetric_fog_density = 0.0
		$traffic/fog_volume.material = fog_material
		$traffic/fog_volume2.material = fog_material
