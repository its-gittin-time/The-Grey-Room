@tool
extends EditorScenePostImport

func _post_import(scene: Node) -> Object:
	iterate(scene)
	return scene

func iterate(node: Node) -> void:
	if node is MeshInstance3D:
		node.position = Vector3.ZERO
		node.rotation = Vector3.ZERO
	for child in node.get_children():
			iterate(child)
