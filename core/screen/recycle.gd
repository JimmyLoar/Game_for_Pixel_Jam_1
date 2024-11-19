extends MarginContainer

@onready var click_area: Node2D = $VBoxContainer/SubViewportContainer/SubViewport/ClickArea
@onready var button: Button = $VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/Button

@onready var recipe_selecter: PanelContainer = $VBoxContainer/PanelContainer/RecipeSelecter
@onready var self_recipe_selecter: PanelContainer = $VBoxContainer/PanelContainer/RecipeSelecter2
@onready var recipe_display: VBoxContainer = $VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/RecipeDisplay
@onready var progress_bar: ProgressBar = $VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/ProgressBar



func _ready() -> void:
	button.pressed.connect(_on_pressed_self_selecter)
	click_area.clicked.connect(_on_clicked)


func _on_pressed_self_selecter():
	self_recipe_selecter.show()
	self_recipe_selecter.recipe_selected.connect(_on_selected, CONNECT_ONE_SHOT)


var currect_recipe: RecipeI
var clicks = 0
func _on_selected(recipe: RecipeI):
	currect_recipe = recipe
	recipe_display.recipe = recipe
	self_recipe_selecter.hide()
	progress_bar.max_value = recipe.execution_time / (Properties.get_value("mining_speed") / 10)
	

func _on_clicked():
	if not currect_recipe: 
		return
	
	progress_bar.value += 0.5
	if progress_bar.value >= progress_bar.max_value:
		_on_complite()


func _on_complite():
	progress_bar.max_value = currect_recipe.execution_time / (Properties.get_value("mining_speed") / 10)
	var resource = currect_recipe.get_resource()
	if not check_currency(resource):
		return
	
	progress_bar.value = 0
	for i in resource.size() / 2:
		if resource[i * 2 +1] <= 0:
			continue
		var multiper = Properties.get_value("mining_reward") if i > 2 else -1
		var value = resource[i * 2 +1] * multiper
		Currency.add_value_id(resource[i * 2], value)
		$VBoxContainer/AudioStreamPlayer.play()



func check_currency(resource: Array) -> bool:
	for i in range(3):
		var prise = resource[i * 2 + 1]
		if prise == 0: 
			continue
		
		var _id = resource[i * 2]
		if not Currency.has_value_for_id(_id, prise):
			return false
	return true
