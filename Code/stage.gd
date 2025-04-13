class_name Stage extends Node2D


@export var music:AudioFile


func _ready() -> void:
	await get_tree().create_timer(3).timeout
	if music: Audio.play_audio(music)
	Signals.ToggleUi.emit(&"play_ui", true)
	Signals.ToggleUi.emit(&"radials", true)
	Signals.ToggleLoadingScreen.emit(false)
