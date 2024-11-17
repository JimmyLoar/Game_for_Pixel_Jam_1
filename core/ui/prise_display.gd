@tool
class_name PriseDisplay
extends CurrencyDisplay

@export_range(0, 1500, 1, "or_greater") var prise: int = 0:
	set(value):
		prise = value
		update_value(_name)


func update_value(currency_name: String = ''):
	if _name != currency_name:
		return 
	
	if not label:
		label = $HBoxContainer/Label
	
	label.text = "".humanize_size(prise)
	self.visible = prise > 0


func check_has_prise() -> bool:
	return Currency.has_value(_name, prise)
