class_name Ship extends Node2D


const RADIUS:float = 40
const CENTER:Vector2 = Vector2(90, 90)
const SPEED:float = 1.5
const ACCELERATION:float = 200.0


@onready var collector: Area2D = %collector

var degree:float = 270
var direction:float = 0.0
var total_material:int = 0
var current_material:int = 0
var speed_level:int = 0
var current_speed:float = SPEED + (speed_level * 0.05)
var collector_level:int = 0
var collector_chance:float = collector_level * 0.01
var generator_level:int = 0
var generated_value:int = int(generator_level * 0.25)
var recycler_level:int = 0
var recycle_chance:float = recycler_level * 0.01


func _ready() -> void:
	global_position = (Utilities.get_point_on_circle(degree) * RADIUS) + CENTER
	collector.area_entered.connect(_collector_area_enterd)
	Signals.DebugAddMaterial.connect(_debug_add_material)
	Signals.UpgradeAdded.connect(_upgrade)
	Signals.UpgradeCost.connect(_upgrade_cost)
	

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("left", "right")
	degree = move_toward(degree, degree + (direction * SPEED), delta * ACCELERATION)
	global_position = (Utilities.get_point_on_circle(degree) * RADIUS) + CENTER
	rotation_degrees = degree + 90


func _collector_area_enterd(area:Area2D) -> void:
	if area is StarMaterial:
		var to_add:int = area.collect()
		total_material += to_add
		current_material += to_add
		Signals.TotalMaterialUpdated.emit(total_material)
		Signals.CurrentMaterialUpdated.emit(current_material)


func _debug_add_material(value:int) -> void:
	total_material += value
	current_material += value
	Signals.TotalMaterialUpdated.emit(total_material)
	Signals.CurrentMaterialUpdated.emit(current_material)


func _upgrade(id:StringName, value) -> void:
	match id:
		&"speed":
			speed_level = value
		&"collector":
			collector_level = value
		&"generator":
			generator_level = value
		&"recycler":
			recycler_level = value
		_:
			pass


func _upgrade_cost(cost:int) -> void:
	current_material -= cost
	Signals.CurrentMaterialUpdated.emit(current_material)
