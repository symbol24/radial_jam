class_name Credits extends Control


@onready var btn_back: TextureButton = %btn_back


func _ready() -> void:
	visibility_changed.connect(_visibility_changed)
	btn_back.pressed.connect(_btn_back_pressed)
	await get_tree().create_timer(0.2).timeout
	btn_back.grab_focus()
	

func _visibility_changed() -> void:
	if visible: 
		await get_tree().create_timer(0.2).timeout
		btn_back.grab_focus()


func _btn_back_pressed() -> void:
	Signals.ToggleUi.emit(&"credits", false)
