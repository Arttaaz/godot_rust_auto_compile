@tool
extends EditorPlugin

func _enter_tree() -> void:
	pass

func _enable_plugin() -> void:
	if ProjectSettings.get_setting("rust/manifest_path") == null:
		ProjectSettings.set_setting("rust/manifest_path", "")
		ProjectSettings.set_setting("rust/cargo_path", "")
		
		var info_manifest = {
			"name": "rust/manifest_path",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_GLOBAL_FILE,
			"hint_string": "*.toml"
		}
		var info_cargo = {
			"name": "rust/cargo_path",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_GLOBAL_FILE,
		}
		
		ProjectSettings.add_property_info(info_manifest)
		ProjectSettings.add_property_info(info_cargo)
		ProjectSettings.save()
	pass

func _build():
	var output = []
	var cargo_path = ProjectSettings.get_setting("rust/cargo_path")
	var manifest_path = ProjectSettings.get_setting("rust/manifest_path")
	
	# if no cargo or manifest path just skip building the library
	if cargo_path == null or manifest_path == null:
		return true

	var exit_code = OS.execute(cargo_path, ["build", "--manifest-path", manifest_path], output, true)
	if exit_code != 0:
		for s in output:
			push_error(s)
	return exit_code == 0

func _exit_tree() -> void:
	pass
