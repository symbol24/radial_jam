extends CanvasLayer


@onready var loading_screen: LoadingScreen = %LoadingScreen


func _ready() -> void:
	Signals.ToggleLoadingScreen.connect(_toggle_loading_screen)


func _toggle_loading_screen(display:bool) -> void:
	loading_screen.visible = display
