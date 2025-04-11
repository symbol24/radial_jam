extends Node


@export var scenes:Array[SceneData]

var loading:bool = false
var progress:Array = []
var to_load:String = ""
var scene_name:StringName = &""
var active_scene


func _ready() -> void:
	Signals.LoadScene.connect(_load)


func _process(_delta: float) -> void:
	if loading:
		var status:ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(to_load, progress)
		if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			_complete_load()


func _load(id:StringName, loading_screen:bool = false) -> void:
	to_load =  _get_scene_uid(id)
	scene_name = id
	if to_load != "":
		Signals.ToggleLoadingScreen.emit(loading_screen)
		var error = ResourceLoader.load_threaded_request(to_load)
		if error != OK:
			push_error("Error %s loading %s into ResourceLoader." % [error_string(error), id])
			scene_name = &""
			return
		
		loading = true


func _complete_load() -> void:
	loading = false
	
	if active_scene != null:
		var temp = active_scene
		active_scene = null
		temp.queue_free.call_deferred()
	
	active_scene = ResourceLoader.load_threaded_get(to_load).instantiate()
	add_child(active_scene)
	if not active_scene.is_node_ready(): await active_scene.ready
	
	to_load = ""
	Signals.SceneLoaded.emit(scene_name)
	scene_name = &""


func _get_scene_uid(id:StringName) -> String:
	for each in scenes:
		if each.id == id:
			return each.uid
	push_warning("No scene found with id: ", id)
	return ""
