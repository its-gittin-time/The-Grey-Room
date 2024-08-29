class_name TrafficLight extends Node3D

const green = preload("res://materials/green_light.tres")
const orange = preload("res://materials/orange_light.tres")
const red = preload("res://materials/red_light.tres")
const off = preload("res://materials/screen.tres")
static var lights : Array[StandardMaterial3D] = [green, orange, red]
static var green_place := 0
static var orange_place := 1
static var red_place := 2

enum LIGHT_CODES {
	GREEN_LIGHT,
	ORANGE_LIGHT,
	RED_LIGHT
}

@onready var mesh := $"traffic light horizontal v1/Cube_182"

func _ready() -> void:
	change_lights(LIGHT_CODES.GREEN_LIGHT)

func change_lights(light: int) -> void:
	#print(green_place, orange_place, red_place)
	mesh.set_surface_override_material(1, off)
	mesh.set_surface_override_material(2, off)
	mesh.set_surface_override_material(3, off)
	if light == LIGHT_CODES.GREEN_LIGHT:
		mesh.set_surface_override_material(green_place + 1, green)
	elif light == LIGHT_CODES.ORANGE_LIGHT:
		mesh.set_surface_override_material(orange_place + 1, orange)
	elif light == LIGHT_CODES.RED_LIGHT:
		mesh.set_surface_override_material(red_place + 1, red)

func update_lights() -> void:
	#print(green_place, orange_place, red_place)
	green_place = lights.find(green)
	orange_place = lights.find(orange)
	red_place = lights.find(red)
	#print(green_place, orange_place, red_place, lights)
	mesh.set_surface_override_material(1, off)
	mesh.set_surface_override_material(2, off)
	mesh.set_surface_override_material(3, off)
