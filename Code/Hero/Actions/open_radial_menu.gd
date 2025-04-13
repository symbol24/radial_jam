class_name OpenRadialMenu extends HeroAction


@export var radial_menu_id:String
@export var input_id:StringName

var open:bool = false


func _input(event: InputEvent) -> void:
	if can_input:
		if event.is_action_pressed(input_id):
			Signals.ToggleRadialMenu.emit(radial_menu_id, !open)
			open = !open
			can_input = false


func _ready() -> void:
	assert(radial_menu_id != "", "%s is missing Radial Menu id" % name)
	assert(input_id != &"", "%s is missing input id" % name)
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.ItemSelected.connect(_item_selected)


func _item_selected(_name:StringName, _item:StringName) -> void:
	if _name == radial_menu_id:
		open = !open
