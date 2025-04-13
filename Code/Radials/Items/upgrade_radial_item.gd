class_name UpgardeRadialItem extends RadialItem


@onready var cost: Label = %cost

var can_select:bool = false


func _ready() -> void:
	visibility_changed.connect(_visibility_changed)


func setup_item(new_data:RadialItemData, radius:float, _degrees:float) -> void:
	super(new_data, radius, _degrees)
	cost.text = str(data.cost)
	cost.position.x = -cost.size.x / 2
	cost.position.y = -(radius - icon.size.y)
	if not data.visible_at_create: hide()


func _visibility_changed() -> void:
	cost.text = str(data.cost)
	cost.position.x = -cost.size.x / 2
