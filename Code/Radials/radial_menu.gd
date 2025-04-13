class_name RadialMenu extends Control


const ITEM:PackedScene = preload("uid://d03y0ciag3dk3")
const UPGRADEITEM:PackedScene = preload("uid://bfkqp1ekkxod0")
const START_POS:Vector2 = Vector2(90, 90)
const RADIUS:float = 70.0
const ROTTIME:float = 0.5


@export var rotate_sfx:AudioFile
@export var select_sfx:AudioFile
@export var open_sfx:AudioFile

@onready var selector: NinePatchRect = %selector
@onready var items: Node2D = %items

var radial_items:Array[RadialItem] = []
var focused_item:int = 0
var data:RadialMenuData
var rotating:bool = false


func setup_menu(new_data:RadialMenuData) -> void:
	data = new_data
	var i:int = 0
	selector.position.y = -RADIUS
	for each in data.items:
		var item:PackedScene = UPGRADEITEM if each is UpgradeItemData else ITEM
		var new_item:RadialItem = item.instantiate()
		items.add_child(new_item)
		if not new_item.is_node_ready(): await new_item.ready
		new_item.setup_item(each, RADIUS, 360/data.items.size()*i)
		new_item.name = each.id + &"_item"
		new_item.position = Vector2.ZERO
		radial_items.append(new_item)
		i += 1


func toggle_menu(display:bool) -> void:
	visible = display
	if visible: Audio.play_audio(open_sfx)


func move_selection(left:bool) -> void:
	if visible:
		var direction:int = 1 if left else -1
		_rotate(items.rotation_degrees + (360/data.items.size() * direction), -direction)


func select() -> void:
	if visible and radial_items[focused_item].is_visible() and not rotating:
		Audio.play_audio(select_sfx)
		Signals.ItemSelected.emit(data.id, radial_items[focused_item].data.id)


func get_item_by_id(id:StringName) -> RadialItem:
	for each in radial_items:
		if each.data.id == id: return each
	return null


func _rotate(target:float, direction:int) -> void:
	if not rotating:
		Audio.play_audio(rotate_sfx)
		rotating = true
		var tween:Tween = create_tween()
		tween.finished.connect(_finish_move.bind(direction))
		tween.tween_property(items, "rotation_degrees", target, RadialManager.INPUTDELAY)
		


func _finish_move(direction:int) -> void:
	focused_item += direction
	if focused_item < 0: focused_item = radial_items.size() - 1
	elif focused_item >= radial_items.size(): focused_item = 0
	rotating = false


func _set_positions() -> void:
	var item_size:float = 360 / radial_items.size()
	var i:int = 0
	while i < radial_items.size():
		var rad:float = deg_to_rad(item_size * i)
		radial_items[i].position.x = RADIUS * cos(rad)
		radial_items[i].position.y = RADIUS * sin(rad)
		i += 1
