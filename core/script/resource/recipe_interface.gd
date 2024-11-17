@tool
class_name RecipeI
extends Resource

var database: Database = load(ProjectSettings.get_setting("resource_databases/main_path", ""))

@export_placeholder("enter key") var name_key: String = ""
@export_range(0, 120, 0.001) var execution_time := 1.0


func get_resource() -> Array:
	return []
