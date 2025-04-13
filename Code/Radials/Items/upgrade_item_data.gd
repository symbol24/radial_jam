class_name UpgradeItemData extends RadialItemData


@export var base:int = 100
@export var percent:float = 0.1
@export var visible_at_create:bool = true

var level:int = 0
var cost:int:
	get:
		var new:int = int(previous * percent)
		return base + new
var previous:int = 0


func upgrade(material:int) -> void:
	if material >= cost:
		Signals.UpgradeCost.emit(cost)
		previous = cost
		level += 1
		Signals.UpgradeAdded.emit(id, level)
	else:
		Signals.NotEnoughMaterial.emit()
