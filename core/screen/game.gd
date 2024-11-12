extends PanelContainer


func _on_recycle_clicked() -> void:
	pass # Replace with function body.


func _on_extraction_clicked() -> void:
	Currency.add_value("pixel_empty", Properties.get_value("drop_per_click"))
