extends Sprite2D


func _pressed():
	var tween = create_tween().set_ease(Tween.EaseType.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ONE * 1.2, .03)
	tween.tween_property(self, "scale", Vector2.ONE, .07)
