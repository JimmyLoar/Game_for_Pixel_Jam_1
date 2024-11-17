extends PanelContainer

signal recipe_selected(recipe: RecipeI)

@export var recipe: RecipeI:
	set(value):
		recipe = value
		if is_node_ready():
			recipe_display.recipe = value

@onready var recipe_display: VBoxContainer = $MarginContainer/HBoxContainer/RecipeDisplay
@onready var button: Button = $MarginContainer/HBoxContainer/Button


func _ready() -> void:
	recipe_display.recipe = recipe


	
