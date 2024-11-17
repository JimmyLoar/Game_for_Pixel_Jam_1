extends PanelContainer

signal recipe_selected(recipe: RecipeI)
@onready var container: VBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer

func _ready() -> void:
	for i in container.get_child_count():
		var child = container.get_child(i)
		if not child is PanelContainer: continue
		child.button.pressed.connect(_on_button_pressed.bind(i))


func _on_button_pressed(index: int):
	hide()
	recipe_selected.emit(container.get_child(index).recipe)
