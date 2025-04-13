class_name EnemyData extends Resource


const ACCELERATION:float = 1000.0
const FRICTION:float = 1000.0


@export var id:StringName
@export var uid:String

@export var level:int = 1
@export var starting_hp:int = 1
@export var type_required:Enums.Damage_Type

@export var damage:int = 1
@export var damage_type:Enums.Damage_Type

@export var speed:float = 20.0

var current_hp:int = 1
var max_hp:int = starting_hp + int(level * 0.5)

func setup_data() -> void:
	current_hp = max_hp
