extends Node2D

signal clicked

@onready var sprite: Sprite2D = $Sprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	if get_parent() is SubViewport:
		call_deferred("_update_sprite_position")


func _update_sprite_position():
	var viewport: SubViewport = get_parent()
	sprite.position = viewport.size / 2


func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		clicked.emit()
		gpu_particles_2d.position = get_global_mouse_position()
		gpu_particles_2d.restart()
		$AudioStreamPlayer.play_sound()
