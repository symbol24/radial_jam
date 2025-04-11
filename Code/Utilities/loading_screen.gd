class_name LoadingScreen extends PanelContainer


@export var time_between_chars:float = 2

@onready var loading_label: Label = %loading_label

var timer:float = 0.0:
	set(value):
		timer = value
		if timer >= time_between_chars:
			timer = 0.0
			if loading_label.visible_characters < loading_label.text.length():
				loading_label.visible_characters += 1
			else:
				loading_label.visible_characters = 0


func _ready() -> void:
	loading_label.visible_characters = 0
	
	
func _process(delta: float) -> void:
	if visible: timer += delta
