extends Node2D

@export var self_name := 'w'

@onready var enveroment: Node2D = $Enveroment
@onready var entity: Node2D = $Entity
@onready var decor: Node2D = $Decor



func _on_level_up(level: int = 0, max_level: int = 1, values := {}):
	if not values.has("env_name"):
		breakpoint
	
	var _name = values["env_name"]
	for key in _name.split(","):
		if not key.begins_with(self_name) and not key.begins_with(" " + self_name):
			continue
		enveroment.change_pixels(key.get_slice("/", 1), (fmod(level - 1, 5) + 1) * 0.313)
	
