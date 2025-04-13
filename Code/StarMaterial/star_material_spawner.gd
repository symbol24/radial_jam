class_name StarMaterialSpawner extends Node2D


const MATERIAL:PackedScene = preload("uid://dooxkwhlrhgtb")
const RADIUS:float = 180
const CENTER:Vector2 = Vector2(90, 90)
const LEVELMULTI:float = 0.05
const SPAWNLEVELMULTI:float = 0.25


@export var base_spawn_delay:float = 1.0
@export var min_spawn_delay:float = 0.1
@export var base_spawn_count:int = 1
@export var base_spawn_count_delay:float = 0.3
@export var min_spawn_count_delay:float = 0.05

var current_level:int = 1
var game_timer:float = 0.0
var pool:Array[StarMaterial] = []
var can_spawn:bool = true
var timer_active:bool = true
var spawn_delay:float:
	get:
		return maxf(base_spawn_delay - (LEVELMULTI * current_level), min_spawn_delay) if current_level > 1 else base_spawn_delay
var spawn_timer:float = 500.0:
	set(value):
		spawn_timer = value
		if spawn_timer >= spawn_delay:
			_spawn_star_material()
var inter_delay:float = maxf(base_spawn_count_delay - (base_spawn_count_delay * LEVELMULTI * current_level), min_spawn_count_delay) if current_level > 1 else base_spawn_count_delay
var spawn_count:int:
	get: return base_spawn_count if current_level == 1 else base_spawn_count + int(SPAWNLEVELMULTI * current_level)
var spawning:bool = false
var stage:Node2D = null:
	get:
		if stage == null: stage = get_tree().get_first_node_in_group(&"stage")
		return stage
var ship:Ship = null:
	get:
		if ship == null: ship = get_tree().get_first_node_in_group(&"ship")
		return ship


func _ready() -> void:
	Signals.StarMaterialCollected.connect(_return_to_pool)
	Signals.TotalMaterialUpdated.connect(_check_level)


func _process(delta: float) -> void:
	if can_spawn and timer_active: spawn_timer += delta
	if timer_active: game_timer += delta


func _spawn_star_material() -> void:
	spawn_timer = 0.0
	spawning = true
	timer_active = false
	var i:int = 0
	#print("spawn count: ", spawn_count)
	while i < spawn_count:
		_spawn_one()
		await get_tree().create_timer(inter_delay).timeout
		i += 1
	spawning = false
	timer_active = true


func _spawn_one() -> void:
	var star_material:StarMaterial = _get_star_material()
	stage.add_child(star_material)
	star_material.setup_star_material(_get_value(), ship.collector_chance)
	var deg:int = Utilities.rng.randi_range(0, 360)
	star_material.global_position = (Utilities.get_point_on_circle(deg) * RADIUS) + CENTER


func _get_star_material() -> StarMaterial:
	if not pool.is_empty():
		return pool.pop_front()
	
	return MATERIAL.instantiate()


func _return_to_pool(star_material:StarMaterial) -> void:
	pool.append(star_material)
	stage.remove_child(star_material)


func _get_value() -> int:
	return Utilities.rng.randi_range(1,10) + int(current_level * LEVELMULTI) + ship.generated_value


func _check_level(value:int) -> void:
	if Utilities.levels.has(current_level):
		if value >= Utilities.levels[current_level]["xp_total"]:
			current_level += 1
			Signals.LevelUpgraded.emit(current_level)
			print("Level now: ", current_level)
