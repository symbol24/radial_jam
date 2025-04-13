class_name Stage extends Node2D


func _ready() -> void:
	Signals.ToggleUi.emit(&"play_ui", true)
	Signals.ToggleUi.emit(&"radials", true)
	Signals.ToggleLoadingScreen.emit(false)
