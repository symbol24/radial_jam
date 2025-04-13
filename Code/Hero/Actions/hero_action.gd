class_name HeroAction extends Node2D


var hero:Hero = null:
	get:
		if hero == null: hero = get_parent() as Hero
		return hero
var can_input:bool = true
var input_timer:float = 0.0:
	set(value):
		input_timer = value
		if input_timer >= Ui.INPUTDELAY:
			_reset_input()


func _process(delta: float) -> void:
	if not can_input: input_timer += delta


func _reset_input() -> void:
	input_timer = 0.0
	can_input = true
