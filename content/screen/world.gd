extends Node2D

@onready var enveroment: Node2D = $Enveroment
@onready var entity: Node2D = $Entity
@onready var decor: Node2D = $Decor



func _on_level_up(level: int = 0, max_level: int = 1, _name := 'env/Bg1'):
	if _name.begins_with("env"):
		enveroment.change_pixels(_name.get_slice("/", 1), level * (1.57 / max_level))


func reset():
	pass


func show_world():
	pass


func show_enveroment(_name: String):
	pass
