extends Node3D

@export_file("*.tscn") var next_scene: String = "res://scenes/main_menu.tscn"
@export var spawn_elevator := false

var can_go := false

func _ready() -> void:
	if spawn_elevator:
		if Global.preserved_position:
			Global.bean.position = $marker_3d.global_position - Global.preserved_position
		if Global.preserved_rotation:
			Global.bean.rotation = Global.preserved_rotation + global_rotation
		Global.bean.get_node("camera").rotation.x = Global.preserved_cam_tilt
	await get_tree().create_timer(1.5).timeout
	$animation_player.play("open")
	$area_3d.monitoring = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Bean and $animation_player.current_animation != "close" and can_go:
		$animation_player.play("close")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "open":
		can_go = true
	if anim_name == "close":
		if not $area_3d.has_overlapping_bodies():
			Global.bean.global_position = $marker_3d.global_position
		await get_tree().create_timer(1.25).timeout

		Global.bean.locked = true
		Global.bean.get_node("%loading").show()

		Global.preserved_rotation = Global.bean.global_rotation - global_rotation
		Global.preserved_cam_tilt = Global.bean.get_node("camera").rotation.x


		Global.preserved_position = $marker_3d.global_position - Global.bean.global_position
		#get_tree().root.add_child(TextureRect.new())
		#get_tree().root.get_child(2).size = Vector2(1920,1080)
		#get_tree().root.get_child(2).texture = get_tree().root.get_texture()
		#Global.preserved_position = Vector3(-0.619,0.414,-0.135)
		get_tree().change_scene_to_packed(load(next_scene))

#func _process(_delta: float) -> void:
	#print($marker_3d.global_position - Global.bean.global_position)
	#print($marker_3d.global_position + Global.bean.global_position)
