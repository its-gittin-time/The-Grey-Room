@tool
class_name Wire extends Marker3D

@export_color_no_alpha var wire_colour : Color = Color.WHITE
@export var target_slot : int
var line_radius := 0.05
var line_resolution := 16

@onready var csg_polygon := $csg_polygon_3d
@onready var path_3d := $path_3d
@onready var area_3d := $area_3d
var default_pos : Vector3 = Vector3(-0.001, -0.31, 0)

var begged_point : Vector3
var super_point : Vector3

func _ready() -> void:
	path_3d.curve = path_3d.curve.duplicate()
	csg_polygon.polygon = csg_polygon.polygon.duplicate()
	var coloured_material :StandardMaterial3D = csg_polygon.material_override.duplicate()
	coloured_material.albedo_color = wire_colour
	csg_polygon.material_overlay = csg_polygon.material_overlay.duplicate()
	csg_polygon.material_override = coloured_material
	var circle := PackedVector2Array()
	for degree in line_resolution:
		var coords := Vector2(line_radius * sin(PI * 2 * degree / line_resolution), \
		line_radius * cos(PI * 2 * degree / line_resolution))
		circle.append(coords)
	csg_polygon.polygon = circle
	path_3d.curve.remove_point(1)
	path_3d.curve.add_point(default_pos,Vector3(0.0,0.5,0.0))

func _physics_process(_delta: float) -> void:
	if super_point:
		path_3d.curve.remove_point(1)
		path_3d.curve.add_point(super_point,Vector3(0.0,0.5,0.0))
		area_3d.global_position = begged_point + global_position
	elif begged_point:
		path_3d.curve.remove_point(1)
		path_3d.curve.add_point(begged_point,Vector3(0.0,0.5,0.0))
		area_3d.global_position = begged_point + global_position
	else:
		path_3d.curve.remove_point(1)
		path_3d.curve.add_point(default_pos,Vector3(0.0,0.5,0.0))
		area_3d.position = Vector3.ZERO
