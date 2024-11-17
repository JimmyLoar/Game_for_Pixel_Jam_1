extends VBoxContainer

@export var recipe: RecipeI
@onready var container: HBoxContainer = $HBoxContainer
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var title_label: Label = $"../../HBoxContainer/TitleLabel"



func _ready() -> void:
	update()


func update():
	if not recipe: 
		return
	
	_update_recources()
	_update_vision()
	_update_rich_text()


func _update_recources():
	var resource = recipe.get_resource()
	for i in resource.size() / 2:
		var display: PriseDisplay = container.get_node("PriseDisplay%d" % [i + 1])
		display.update(resource[i * 2])
		display.prise = resource[i * 2 + 1]


func _update_vision():
	$HBoxContainer/Label.visible = $HBoxContainer/PriseDisplay2.visible
	$HBoxContainer/Label2.visible = $HBoxContainer/PriseDisplay3.visible
	$HBoxContainer/Label3.visible = $HBoxContainer/PriseDisplay4.visible


func _update_rich_text():
	rich_text_label.clear()
	var text_key = "TIME_EXECUTION_TEXT" if recipe is RecipeCraft else "TIME_EXTRACT_TEXT" 
	rich_text_label.append_text(
		TranslationServer.translate(text_key) % [recipe.execution_time]
	)
