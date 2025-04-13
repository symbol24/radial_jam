class_name RadialItem extends Control


@onready var icon: TextureRect = %icon

var data:RadialItemData
var degrees:float = 0.0


func setup_item(new_data:RadialItemData, radius:float, _degrees:float) -> void:
	data = new_data.duplicate(true)
	icon.texture = load(data.uid) as CompressedTexture2D
	icon.position.y = -radius
	rotation = deg_to_rad(_degrees)
	degrees = _degrees


func menu_displayed() -> void:
	pass
