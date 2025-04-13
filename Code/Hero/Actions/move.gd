class_name HeroMove extends HeroAction


@export var axis:Array[StringName] = [&"left", &"right", &"up", &"down"]

var direction:Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	direction = Input.get_vector(axis[0], axis[1], axis[2], axis[3])
	if hero != null: 
		hero.velocity = _get_velocity(direction, hero.velocity, delta)
		hero.move_and_slide()


func _get_velocity(_direction:Vector2, _current:Vector2, delta:float) -> Vector2:
	var x:float = _current.x
	var y:float = _current.y
	if _direction != Vector2.ZERO:
		x = move_toward(x, _direction.x * hero.data.get_variable(&"speed"), delta * hero.data.get_variable(&"acceleration"))
		x = clampf(x, -hero.data.get_variable(&"speed"), hero.data.get_variable(&"speed"))
		y = move_toward(y, _direction.y * hero.data.get_variable(&"speed"), delta * hero.data.get_variable(&"acceleration"))
		y = clampf(y, -hero.data.get_variable(&"speed"), hero.data.get_variable(&"speed"))
	
	else:
		x = move_toward(x, 0, delta * hero.data.get_variable(&"friction"))
		x = clampf(x, -hero.data.get_variable(&"speed"), hero.data.get_variable(&"speed"))
		y = move_toward(y, 0, delta * hero.data.get_variable(&"friction"))
		y = clampf(y, -hero.data.get_variable(&"speed"), hero.data.get_variable(&"speed"))
	
	return Vector2(x,y)
