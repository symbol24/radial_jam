class_name Enemy extends CharacterBody2D


@export var debug_data:EnemyData
@export var use_debug:bool = false

var data:EnemyData


func _ready() -> void:
	if use_debug:
		assert(debug_data != null, "%s has no debug data and thus cannot use it!" % name)
		data = debug_data.duplicate()
		data.setup_data()


func receive_damage(damage:Damage) -> void:
	print("receiving damage: ", damage.value)
