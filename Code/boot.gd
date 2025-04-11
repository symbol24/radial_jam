class_name Boot extends Node2D


@onready var animator: AnimationPlayer = %animator

var current:StringName = &"godot"

func _input(_event: InputEvent) -> void:
	if Input.is_anything_pressed():
		print(current)
		_anim_end(current)


func _ready() -> void:
	animator.animation_finished.connect(_anim_end)
	await get_tree().create_timer(1).timeout
	animator.play(current)
	

func _anim_end(anim_name:StringName) -> void:
	if anim_name == &"godot":
		current = &"rid"
		animator.play(&"RESET")
	elif anim_name == &"RESET":
		animator.play(current)
	elif anim_name == &"rid":
		#await get_tree().create_timer(1).timeout
		Signals.LoadScene.emit(&"stage", true)
		queue_free.call_deferred()
