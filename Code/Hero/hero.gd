class_name Hero extends CharacterBody2D


@export var hero_data:HeroData

@onready var animated_sprite: AnimatedSprite2D = %animated_sprite

var data:HeroData = null:
	get:
		if data == null: data = hero_data.duplicate(true)
		return data


func _ready() -> void:
	assert(hero_data != null, "Hero missing data!")
