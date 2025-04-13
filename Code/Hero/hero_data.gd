class_name HeroData extends Resource


@export var speed:float = 100.0
@export var acceleration:float = 500.0
@export var friction:float = 1000.0

@export var starting_hp:int = 2




func get_variable(variable:StringName) -> Variant:
	if get(variable) != null:
		return get(variable)
	return 0
	
