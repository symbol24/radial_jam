class_name HitBox extends Area2D


var parent:CharacterBody2D = null:
	get:
		if parent == null: parent = get_parent() as CharacterBody2D
		return parent


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(area:Area2D) -> void:
	if area.has_method(&"get_damage") and parent.has_method(&"receive_damage"):
		parent.receive_damage(area.get_damage())
