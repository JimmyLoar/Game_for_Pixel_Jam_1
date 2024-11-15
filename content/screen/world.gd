extends Node2D

@export var self_name := 'w'

@onready var enveroment: Node2D = $Enveroment
@onready var entity: Node2D = $Entity
@onready var decor: Node2D = $Decor



func _on_level_up(level: int = 0, max_level: int = 1, _name := 'w/Bg1'):
	for key in _name.split(","):
		if not key.begins_with(self_name):
			continue
		enveroment.change_pixels(key.get_slice("/", 1), (fmod(level - 1, 5) + 1) * 0.313)
	

func reset():
	pass


func show_world():
	pass


func show_enveroment(_name: String):
	pass


func _on_upgrade_panel_w_2_bg_1_bg_3_level_up(level: int = 0, max_level: int = 1, _name := 'env/Bg1') -> void:
	_on_level_up(level, max_level, _name)
