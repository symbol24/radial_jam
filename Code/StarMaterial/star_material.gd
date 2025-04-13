class_name StarMaterial extends Area2D


const RANGES:Array[int] = [1, 10, 10, 20, 20]
const TARGET:Vector2 = Vector2(90,90)
const SPEED:Array[float] = [10, 20, 30]


@onready var animated_sprite: AnimatedSprite2D = %animated_sprite


var value:int = 0
var active:bool = false
var speed:float = 1.0
var ship:Ship = null:
	get:
		if ship == null: ship = get_tree().get_first_node_in_group(&"ship")
		return ship
var collector_triggered:bool = false


func _physics_process(delta: float) -> void:
	if active:
		var target:Vector2 = ship.global_position if collector_triggered else TARGET
		global_position = global_position.move_toward(target, delta * speed)


func setup_star_material(new_value:int, collector_chance:float) -> void:
	value = new_value
	if value >= RANGES[0] and value <= RANGES[1]:
		animated_sprite.play(&"small")
		speed = SPEED[0]
	elif value >= RANGES[2] and value <= RANGES[3]:
		animated_sprite.play(&"medium")
		speed = SPEED[1]
	elif value >= RANGES[4]:
		animated_sprite.play(&"large")
		speed = SPEED[2]
	active = true
	if collector_chance > 0.0:
		var check:float = Utilities.rng.randf()
		if check <= collector_chance: collector_triggered = true
		else: collector_triggered = false
	else:
		collector_triggered = false


func collect() -> int:
	active = false
	get_tree().create_timer(0.1).timeout.connect(_collected)
	return value


func _collected() -> void:
	Signals.StarMaterialCollected.emit(self)
