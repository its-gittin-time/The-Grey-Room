class_name WeightedBox extends RigidBody3D

@export_range(0, 20, 1) var weight : int = 10
@export var colour_material : StandardMaterial3D
@onready var cube_mesh := $"test box v1/Cube_084"

func _ready() -> void:
	cube_mesh.material_overlay = cube_mesh.material_overlay.duplicate()
	cube_mesh.set_surface_override_material(1, cube_mesh.get_surface_override_material(1).duplicate())
	if colour_material:
		colour_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS
	cube_mesh.set_surface_override_material(0, colour_material)

func outline_on() -> void:
	cube_mesh.material_overlay.set_shader_parameter("enabled", true)
	cube_mesh.material_overlay.render_priority = 1
	cube_mesh.get_surface_override_material(0).render_priority = 2
	cube_mesh.get_surface_override_material(1).render_priority = 2

func outline_off() -> void:
	cube_mesh.material_overlay.set_shader_parameter("enabled", false)
	cube_mesh.material_overlay.render_priority = 0
	cube_mesh.get_surface_override_material(0).render_priority = 0
	cube_mesh.get_surface_override_material(1).render_priority = 0
