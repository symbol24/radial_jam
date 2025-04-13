class_name BlackHole extends Area2D


var total_material:int = 0


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(area:Area2D) -> void:
	if area is StarMaterial:
		var amount:int = area.collect()
		total_material += amount
		Signals.BlackHoleSwallowedMaterial.emit(amount)
