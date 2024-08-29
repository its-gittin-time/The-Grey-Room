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
var wire : Wire
var reset_point : Vector3
var locked := false

func _ready() -> void:
	reset_point = global_position
	%fade.modulate = Color.TRANSPARENT
	#fade_out()
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_window().grab_focus()
	SurveillanceCamera.bean = self
	Global.bean = self
	#print(Global.PROTANOPIA)
	RenderingServer.global_shader_parameter_set("colour_matrix", Global.PROTANOPIA)



func get_gravity2() -> float:
	return jump_gravity if velocity.y > 0.0 else fall_gravity

func _physics_process(delta: float) -> void:
	velocity.y -= get_gravity2() * delta
	if Input.is_action_just_pressed("spacebar") and is_on_floor() and not locked:
		velocity.y = jump_velocity
		create_tween().tween_property(camera, "position:y", 0.5, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	elif Input.is_action_pressed("crouch") and is_on_floor() and not locked:
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
	if global_position.y < -10:
		global_position = reset_point
		velocity = Vector3.ZERO
	if wire:
		#var curve : Curve3D = wire.get_node("path_3d").curve
		#curve.remove_point(1)
		#var relative_pos : Vector3 = hand.global_transform.origin - wire.global_transform.origin
		wire.begged_point = hand.global_position - wire.global_position
		#curve.add_point(Vector3(relative_pos),Vector3(0.0,0.25,0.0))
		#wire.get_node("path_3d").curve = curve
	move_and_slide()
	if grabbing and grab_collider:
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
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and not locked:
		rotate_y(-event.screen_relative.x * sensitivity)
		camera.rotate_x(-event.screen_relative.y * sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))
	elif event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
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
		if grab_collider:
			grab_collider.gravity_scale = 1
			grab_collider.collision_layer = 0b100
			grab_collider.collision_mask = 0b111
		grab_collider = null
		joint.node_b = ""
		if wire:
			if wire.super_point:
				wire.begged_point = wire.super_point
			else:
				wire.begged_point = Vector3.ZERO
			wire = null
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
			if collider is Button3D: collider.push()
			elif collider.is_in_group("interactable"): collider.interact()
		elif collider is CSGPolygon3D:
			if collider.get_parent() is Wire:
				grabbing = true
				wire = collider.get_parent()

func disable_outline(child: Node) -> void:
	if child is not GeometryInstance3D: return
	if child.material_overlay:
		child.material_overlay.set_shader_parameter("enabled", false)
		child.material_overlay.render_priority = 0
	if child.material_override:
		child.material_override.render_priority = 0
	elif child is MeshInstance3D:
		if child.get_surface_override_material(0):
			child.get_surface_override_material(0).render_priority = 0

func outline() -> void:
	for box :WeightedBox in get_tree().get_nodes_in_group("box"):
		box.outline_off()
	for node :Node in get_tree().get_nodes_in_group("grabbable"):
		for child : Node in node.get_children():
			disable_outline(child)
	for node :Node in get_tree().get_nodes_in_group("interactable"):
		for child : Node in node.get_children():
			disable_outline(child)
		if node is Button3D:
			for child: Node in node.get_children():
				for grand_child: Node in child.get_children():
					if grand_child is MeshInstance3D:
						grand_child.mesh.surface_get_material(0).render_priority = 0
						grand_child.mesh.surface_get_material(1).render_priority = 0
						grand_child.material_overlay.set_shader_parameter("enabled", false)
						grand_child.material_overlay.render_priority = 0
	for node :Node in get_tree().get_nodes_in_group("wire"):
		for child :Node in node.get_children():
			disable_outline(child)
	if interact_ray.get_collider() is WeightedBox and not grabbing:
		interact_ray.get_collider().outline_on()
		return
	if interact_ray.get_collider() and not grabbing:
		if interact_ray.get_collider() is GeometryInstance3D:
			if interact_ray.get_collider().material_overlay:
				interact_ray.get_collider().material_overlay.set_shader_parameter("enabled", true)
				interact_ray.get_collider().material_overlay.render_priority = 1
				if interact_ray.get_collider().material_override:
					interact_ray.get_collider().material_override.render_priority = 2
				elif interact_ray.get_collider().get_surface_override_material(0):
					interact_ray.get_collider().get_surface_override_material(0).render_priority = 2
				return
		for child : Node in interact_ray.get_collider().get_children():
			if child is GeometryInstance3D:
				if child.material_overlay:
					child.material_overlay.set_shader_parameter("enabled", true)
					child.material_overlay.render_priority = 1
					if child.material_override:
						child.material_override.render_priority = 2
					elif child.get_surface_override_material(0):
						child.get_surface_override_material(0).render_priority = 2
			if child is Button3D:
				for grand_child: Node in child.get_children():
					if grand_child is MeshInstance3D:
						grand_child.get_surface_override_material(0).render_priority = 2
						grand_child.get_surface_override_material(1).render_priority = 2
						grand_child.material_overlay.set_shader_parameter("enabled", true)
						grand_child.material_overlay.render_priority = 1

func fade_in() -> void:
	create_tween().tween_property(%fade, "modulate", Color.WHITE, 1.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

var last_fade_tween : Tween

func fade_out() -> void:
	if last_fade_tween:
		last_fade_tween.kill()
	%fade.modulate = Color.WHITE
	await get_tree().create_timer(0.15).timeout
	last_fade_tween = create_tween()
	last_fade_tween.tween_property(%fade, "modulate", Color.TRANSPARENT, 2)
	last_fade_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
