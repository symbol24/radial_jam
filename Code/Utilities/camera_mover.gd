extends CharacterBody2D


@export var speed:float = 100.0
@export var friction:float = 1000.0
@export var acceleration:float = 700.0

@onready var camera: Camera2D = %camera
@onready var first: RadialMenu2D = %first


func _ready() -> void:
	await get_tree().create_timer(3).timeout
	Signals.ToggleLoadingScreen.emit(false)


func _process(delta: float) -> void:
	var direction:Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = _move_to(direction, velocity, delta)
	move_and_slide()


func _move_to(direction:Vector2, current_vel:Vector2, delta:float) -> Vector2:
	var clamped_x:float = clampf(direction.x, -0.7, 0.7) if (direction.x == 1 and direction.y == 1) or (direction.x == -1 and direction.y == -1) else direction.x
	var clamped_y:float = clampf(direction.x, -0.7, 0.7) if (direction.x == 1 and direction.y == 1) or (direction.x == -1 and direction.y == -1) else direction.y
	var x:float
	var y:float
	if direction != Vector2.ZERO:
		x = clampf(move_toward(current_vel.x, current_vel.x + clamped_x, delta * acceleration), -speed, speed)
		y = clampf(move_toward(current_vel.y, current_vel.y + clamped_y, delta * acceleration), -speed, speed)
		return Vector2(x, y)
		
	x = move_toward(current_vel.x, 0, delta * friction)
	y = move_toward(current_vel.y, 0, delta * friction)
	return Vector2(x, y)
