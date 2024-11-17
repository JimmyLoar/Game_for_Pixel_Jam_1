extends VBoxContainer

@export var recipe: RecipeI:
	set(value):
		recipe = value
		if is_node_ready():
			update()

@onready var container: HBoxContainer = $HBoxContainer
@onready var rich_text_label: RichTextLabel = $RichTextLabel



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
	for i in range(4):
		var display: PriseDisplay = container.get_node("PriseDisplay%d" % [i + 1])
		if i >= resource.size() / 2:
			display.prise = 0
			continue
		
		display.update(resource[i * 2])
		display.prise = resource[i * 2 + 1]


func _update_vision():
	var vision_1 = $HBoxContainer/PriseDisplay1.visible
	var vision_2 = $HBoxContainer/PriseDisplay2.visible
	var vision_3 = $HBoxContainer/PriseDisplay3.visible
	var vision_4 = $HBoxContainer/PriseDisplay4.visible
	$HBoxContainer/Label.visible = vision_1 && vision_2
	$HBoxContainer/Label2.visible = vision_2 && vision_3
	$HBoxContainer/Label3.visible = (vision_1 || vision_2 || vision_3) && vision_4


func _update_rich_text():
	if recipe.execution_time == 0:
		rich_text_label.hide()
		return
	
	rich_text_label.clear()
	var text_key = "TIME_EXECUTION_TEXT" if recipe is RecipeCraft else "TIME_EXTRACT_TEXT" 
	rich_text_label.append_text(
		TranslationServer.translate(text_key) % [recipe.execution_time]
	)
