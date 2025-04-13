class_name AbilityData extends Resource


@export var id:StringName
@export var ability_uid:String

@export var shoot_delay:float = 1.0
@export var count_per_shot:int = 1
@export var delay_between_count:float = 0.3
@export var damage:int
@export var damage_type:Enums.Damage_Type

@export_group("Projectile")
@export var speed:float = 200.0
@export var pierce_hp:int = 1
@export var projectile_uid:String
