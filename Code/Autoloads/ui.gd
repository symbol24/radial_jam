extends CanvasLayer


const INPUTDELAY:float = 0.2


@onready var loading_screen: LoadingScreen = %LoadingScreen
@onready var radial_manager: RadialManager = %RadialManager


func _ready() -> void:
	Signals.ToggleLoadingScreen.connect(_toggle_loading_screen)
	Signals.ToggleUi.connect(_toggle_ui)


func _toggle_loading_screen(display:bool) -> void:
	loading_screen.visible = display


func _toggle_ui(id:StringName, display:bool) -> void:
	if id == &"radials": 
		if display: radial_manager.show()
		else: radial_manager.hide()
