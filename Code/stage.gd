class_name Stage extends Control


@onready var first: RadialMenu2D = %first


func _ready() -> void:
	first.selected_by_name.connect(_first_options)
	
	
func _first_options(option_name:StringName) -> void:
	match option_name:
		&"Play":
			pass
		&"Settings":
			pass
		&"Credits":
			pass
		_:
			pass
