extends ItemList

const BUNDLED_MANIFEST_PATH: String = "res://Assets/World/maps_manifest.json"
const BUNDLED_MAPS_DIR: String = "res://Assets/World"
const USER_MAPS_DIR: String = "user://maps"
const USER_MANIFEST_PATH: String = "user://maps/maps_manifest.json"
const DEFAULT_MAP_PATH: String = "res://Assets/World/WorldDev2D.tscn"
const MAP_NAME_META_KEY: StringName = &"MapName"
const BUNDLED_HEADER_TEXT: String = "---- Bundled Maps ----"
const COMMUNITY_HEADER_TEXT: String = "---- Community Maps ----"

var _maps_by_index: Dictionary[int, PackedScene] = {}
var _header_indices: Dictionary[int, bool] = {}

func _ready() -> void:
	_rebuild_map_list()
	_select_default_map()

func _rebuild_map_list() -> void:
	clear()
	_maps_by_index.clear()
	_header_indices.clear()

	var bundled_maps: Array[Dictionary] = _load_maps_from_manifest(BUNDLED_MANIFEST_PATH)
	bundled_maps.append_array(_scan_maps_directory(BUNDLED_MAPS_DIR))
	var community_maps: Array[Dictionary] = _load_maps_from_manifest(USER_MANIFEST_PATH)
	community_maps.append_array(_scan_maps_directory(USER_MAPS_DIR))

	var seen_paths: Dictionary[String, bool] = {}
	bundled_maps = _dedupe_and_sort_maps(bundled_maps, seen_paths)
	community_maps = _dedupe_and_sort_maps(community_maps, seen_paths)

	if not bundled_maps.is_empty():
		_add_header(BUNDLED_HEADER_TEXT)
		_add_map_entries(bundled_maps)

	if not community_maps.is_empty():
		_add_header(COMMUNITY_HEADER_TEXT)
		_add_map_entries(community_maps)

func _on_ItemList_item_selected(index: int) -> void:
	if _header_indices.has(index):
		return
	if not _maps_by_index.has(index):
		return
	Global.map = _maps_by_index[index] as PackedScene

func _select_default_map() -> void:
	var selected_index: int = -1

	for index: int in _maps_by_index.keys():
		var map_scene: PackedScene = _maps_by_index[index] as PackedScene
		if map_scene == null:
			continue

		var scene_path: String = map_scene.resource_path
		if scene_path == DEFAULT_MAP_PATH:
			selected_index = index
			break
		if selected_index == -1:
			selected_index = index

	if selected_index != -1:
		select(selected_index)
		Global.map = _maps_by_index[selected_index] as PackedScene

func _add_header(text: String) -> void:
	var index: int = item_count
	add_item(text)
	set_item_disabled(index, true)
	_header_indices[index] = true

func _add_map_entries(entries: Array[Dictionary]) -> void:
	for entry: Dictionary in entries:
		var display_name: String = str(entry.get("name", "")).strip_edges()
		var map_scene: PackedScene = entry.get("scene", null) as PackedScene
		if display_name.is_empty() or map_scene == null:
			continue

		var index: int = item_count
		add_item(display_name)
		_maps_by_index[index] = map_scene

func _load_maps_from_manifest(path: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if not FileAccess.file_exists(path):
		return result

	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return result

	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not (parsed is Dictionary):
		return result

	var parsed_dict: Dictionary = parsed
	var maps_array: Variant = parsed_dict.get("maps", [])
	if not (maps_array is Array):
		return result

	for map_entry_variant: Variant in maps_array:
		if not (map_entry_variant is Dictionary):
			continue
		var map_entry: Dictionary = map_entry_variant
		var scene_path: String = str(map_entry.get("path", ""))
		if scene_path.is_empty():
			continue

		var map_scene: PackedScene = load(scene_path) as PackedScene
		if map_scene == null:
			continue

		var display_name: String = str(map_entry.get("name", "")).strip_edges()
		if display_name.is_empty():
			display_name = _resolve_display_name(scene_path)

		result.append({
			"path": scene_path,
			"name": display_name,
			"scene": map_scene,
		})

	return result

func _scan_maps_directory(path: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var directory: DirAccess = DirAccess.open(path)
	if directory == null:
		return result

	directory.list_dir_begin()
	var file_name: String = directory.get_next()

	while file_name != "":
		if not directory.current_is_dir() and file_name.begins_with("World") and file_name.ends_with(".tscn"):
			var scene_path: String = "%s/%s" % [path, file_name]
			var map_scene: PackedScene = load(scene_path) as PackedScene
			if map_scene != null:
				result.append({
					"path": scene_path,
					"name": _resolve_display_name(scene_path),
					"scene": map_scene,
				})
		file_name = directory.get_next()

	directory.list_dir_end()
	return result

func _resolve_display_name(scene_path: String) -> String:
	var map_scene: PackedScene = load(scene_path) as PackedScene
	if map_scene != null:
		var instance: Node = map_scene.instantiate()
		if instance != null:
			if instance.has_meta(MAP_NAME_META_KEY):
				var meta_value: String = str(instance.get_meta(MAP_NAME_META_KEY)).strip_edges()
				instance.queue_free()
				if not meta_value.is_empty():
					return meta_value
			instance.queue_free()

	var base_name: String = scene_path.get_file().get_basename()
	if base_name.is_empty():
		return scene_path
	return base_name

func _dedupe_and_sort_maps(entries: Array[Dictionary], seen_paths: Dictionary[String, bool]) -> Array[Dictionary]:
	var unique_entries: Array[Dictionary] = []
	for entry: Dictionary in entries:
		var scene_path: String = str(entry.get("path", ""))
		if scene_path.is_empty():
			continue
		if seen_paths.has(scene_path):
			continue
		seen_paths[scene_path] = true
		unique_entries.append(entry)

	unique_entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var name_a: String = str(a.get("name", "")).to_lower()
		var name_b: String = str(b.get("name", "")).to_lower()
		return name_a < name_b
	)

	return unique_entries
