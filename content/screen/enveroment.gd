extends Node2D


func _ready() -> void:
	for child in get_children():
		change_pixels(child.name, 0.0, 0.001)


func change_pixels(node_name: String, value: float, time := 0.5):
	if not has_node(node_name): return
	var tween = create_tween()
	var node = get_node(node_name)
	tween.tween_property(node.material, "shader_parameter/time", value, time)
