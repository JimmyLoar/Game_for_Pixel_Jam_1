extends Node2D

signal clicked

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if get_parent() is SubViewport:
		call_deferred("_update_sprite_position")


func _update_sprite_position():
	var viewport: SubViewport = get_parent()
	sprite.position = viewport.size / 2


func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		clicked.emit()
		$AudioStreamPlayer.play_sound()
