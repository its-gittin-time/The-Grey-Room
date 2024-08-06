class_name Bean extends CharacterBody3D

const SPEED = 7.0
const JUMP_VELOCITY = 5

@export var sensitivity := 0.0015

@export var camera : Camera3D
@export var interact_ray : RayCast3D
@export var joint : Generic6DOFJoint3D
@export var hand : StaticBody3D

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_fall : float

@onready var jump_velocity := (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity := (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity := (2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)


var grab_collider : RigidBody3D
var grab_force := 500
var grabbing := false
var grab_pos : Vector3


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_window().grab_focus()
	SurveillanceCamera.bean = self

func get_gravity2() -> float:
	return jump_gravity if velocity.y > 0.0 else fall_gravity

func _physics_process(delta: float) -> void:
	velocity.y -= get_gravity2() * delta
	if Input.is_action_just_pressed("spacebar") and is_on_floor():
		velocity.y = jump_velocity
		create_tween().tween_property(camera, "position:y", 0.5, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	elif Input.is_action_pressed("crouch") and is_on_floor():
			create_tween().tween_property(camera, "position:y", 0.0, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	elif Input.is_action_just_released("crouch"):
			create_tween().tween_property(camera, "position:y", 0.5, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	if grabbing:
		#var grab_distance := 2
		#grab_pos = camera.global_position - (camera.global_transform.basis.z.normalized() * grab_distance)
		#grab_collider.linear_velocity = ((grab_pos-grab_collider.global_position).normalized() * grab_force * delta) * grab_pos.distance_to(grab_collider.global_position)
		grab_collider.linear_velocity = (hand.global_transform.origin - grab_collider.global_transform.origin) * grab_force * delta

var delta_count := 0

func _process(_delta: float) -> void:
	if delta_count == 0:
		delta_count = 1
		outline()
	else:
		delta_count = 0
		return
	$label.text = str(Performance.get_monitor(Performance.TIME_FPS))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		grab()
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.screen_relative.x * sensitivity)
		camera.rotate_x(-event.screen_relative.y * sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))
	elif event is InputEventKey:
		if event.is_action_pressed("interact"):
			pass
		if OS.has_feature("debug"):
			if event.is_action_pressed("one"):
				RenderingServer.global_shader_parameter_set("colour_matrix", Global.PROTANOPIA)
			elif event.is_action_pressed("two"):
				RenderingServer.global_shader_parameter_set("colour_matrix", Global.DEUTERANOPIA)
				#position = Vector3.ZERO
			elif event.is_action_pressed("three"):
				RenderingServer.global_shader_parameter_set("colour_matrix", Global.TRITANOPIA)
			elif event.is_action_pressed("four"):
				RenderingServer.global_shader_parameter_set("colour_matrix", Global.NORMAL_VISION)

func grab() -> void:
	if grabbing:
		grabbing = false
		grab_collider.gravity_scale = 1
		grab_collider.collision_layer = 0b100
		grab_collider.collision_mask = 0b111
		grab_collider = null
		joint.node_b = ""
	else:
		var collider := interact_ray.get_collider()
		if collider is RigidBody3D:
			if collider.is_in_group("grabbable"):
				grabbing = true
				grab_collider = collider
				joint.node_b = grab_collider.get_path()
				grab_collider.gravity_scale = 0
				grab_collider.collision_layer = 0b000
				grab_collider.collision_mask = 0b101
		elif collider is AnimatableBody3D:
			if collider is Button3D:
				collider.push()
			elif collider.is_in_group("interactable"):
				collider.interact()

func outline() -> void:
	for node in get_tree().get_nodes_in_group("grabbable"):
		for child in node.get_children():
			if child is MeshInstance3D:
				if child.material_overlay:
					child.material_overlay.set_shader_parameter("enabled", false)
					child.material_overlay.render_priority = 0
				if child.material_override:
					child.material_override.render_priority = 0
				elif child.get_surface_override_material(0):
					child.get_surface_override_material(0).render_priority = 0
	for node in get_tree().get_nodes_in_group("interactable"):
		for child in node.get_children():
			if child is MeshInstance3D:
				if child.material_overlay:
					child.material_overlay.set_shader_parameter("enabled", false)
					child.material_overlay.render_priority = 0
				if child.material_override:
					child.material_override.render_priority = 0
				elif child.get_surface_override_material(0):
					child.get_surface_override_material(0).render_priority = 0
	if interact_ray.get_collider() and not grabbing:
		if interact_ray.get_collider() is Button3D:
			if interact_ray.get_collider().pushing: return
		for child in interact_ray.get_collider().get_children():
			if child is MeshInstance3D:
				if child.material_overlay:
					child.material_overlay.set_shader_parameter("enabled", true)
					child.material_overlay.render_priority = 1
					if child.material_override:
						child.material_override.render_priority = 2
					elif child.get_surface_override_material(0):
						child.get_surface_override_material(0).render_priority = 2
