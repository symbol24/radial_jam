extends Camera2D


@export var radials:Array[Control] = []
@export var limit:int = 1000
@export var speed:float = 100.0
@export var friction:float = 1000.0
@export var acceleration:float = 700.0


func _ready() -> void:
	if limit_left != -limit:
		limit_left = -limit
		limit_top = -limit/2
		limit_right = limit
		limit_bottom= limit/2
