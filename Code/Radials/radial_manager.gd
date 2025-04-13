class_name RadialManager extends Control


const INPUTDELAY:float = 0.2
const CENTERPOSITION:Vector2 = Vector2(90,90)
const RADIALMENU:PackedScene = preload("uid://hwjol52yqrxy")


@export var radia_menu_datas:Array[RadialMenuData] = []
@export var menu_close_sfx:AudioFile

var radials:Array[RadialMenu] = []
var active_radial:RadialMenu = null
var can_input:bool = true
var input_timer:float = 0.0:
	set(value):
		input_timer = value
		if input_timer >= INPUTDELAY:
			input_timer = 0.0
			can_input = true
var delay_timer:float = 0.0:
	set(value):
		delay_timer = value
		if delay_timer >= INPUTDELAY:
			_trigger_input()
var left:bool = false
var right:bool = false
var menu_up:bool = false
var can_upgrade:bool = false
var ship:Ship = null:
	get:
		if ship == null: ship = get_tree().get_first_node_in_group(&"ship")
		return ship


func _input(event: InputEvent) -> void:
	if not menu_up and is_visible():
		if active_radial and active_radial.is_visible():
			if event.is_action_pressed(&"left"):
				left = true
				_trigger_input()
			if event.is_action_released(&"left"):
				left = false
			if event.is_action_pressed(&"right"):
				right = true
				_trigger_input()
			if event.is_action_released(&"right"):
				right = false
			if event.is_action_pressed(&"select"):
				if not active_radial.rotating:
					active_radial.select()
					_toggle_radial(active_radial.data.id, false)
			if event.is_action_pressed(&"pause"):
				Audio.play_audio(menu_close_sfx)
				_toggle_radial(active_radial.data.id, false)
				if get_tree().paused: get_tree().paused = false
		else:
			if event.is_action_pressed(&"pause"):
				_toggle_radial(&"pause_menu", true)
				get_tree().paused = true
			elif can_upgrade and event.is_action_pressed(&"upgrade"):
				_toggle_radial(&"upgrades_menu", true)
				get_tree().paused = true


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.ToggleRadialMenu.connect(_toggle_radial)
	Signals.ItemSelected.connect(_item_selected)
	Signals.ToggleUi.connect(_toggle_menu_up)
	Signals.LevelUpgraded.connect(_upgrade_check)


func _process(delta: float) -> void:
	if not can_input: input_timer += delta
	if left or right: delay_timer += delta


func _trigger_input() -> void:
	delay_timer = 0.0
	if left:
		active_radial.move_selection(true)
	elif right:
		active_radial.move_selection(false)


func _toggle_radial(radial_name:StringName, display:bool) -> void:
	if display:
		if active_radial: active_radial.toggle_menu(false)
		active_radial = _get_radial_by_name(radial_name)
		active_radial.toggle_menu(true)
	else:
		if active_radial and radial_name == active_radial.data.id:
			active_radial.toggle_menu(false)
			active_radial = null


func _get_radial_by_name(_name:StringName) -> RadialMenu:
	for each in radials:
		if each.data.id == _name:
			return each
	
	var r_data:RadialMenuData = _get_uid_by_name(_name)
	var new_radial:RadialMenu = RADIALMENU.instantiate()
	add_child(new_radial)
	new_radial.setup_menu(r_data)
	new_radial.global_position = CENTERPOSITION
	radials.append(new_radial)
	return new_radial
	

func _get_uid_by_name(_name:StringName) -> RadialMenuData:
	for each in radia_menu_datas:
		if each.id == _name: return each
	return null


func _item_selected(radial_menu:StringName, item_id:StringName) -> void:
	match radial_menu:
		&"pause_menu":
			match item_id:
				&"audio_item":
					Signals.ToggleUi.emit(&"settings", true)
				&"back_item":
					get_tree().paused = false
				&"credits_item":
					Signals.ToggleUi.emit(&"credits", true)
				&"how_to_item":
					Signals.ToggleUi.emit(&"how_to", true)
				_:
					pass
		&"upgrades_menu":
			var radial:RadialMenu = _get_radial_by_id(&"upgrades_menu")
			var item:UpgardeRadialItem = radial.get_item_by_id(item_id) if radial else null
			if item: item.data.upgrade(ship.current_material)
			get_tree().paused = false
		_:
			if get_tree().paused: get_tree().paused = false
			active_radial = null


func _toggle_menu_up(_id:StringName, display:bool) -> void:
	if not _id in [&"play_ui", &"radials"]:
		menu_up = display


func _upgrade_check(level:int) -> void:
	if not can_upgrade and level >= 2:
		can_upgrade = true
	
	var unlock:Dictionary = {}
	if Utilities.unlocks.has(level):
		unlock = Utilities.unlocks[level]
	
	if not unlock.is_empty():
		var key:StringName = unlock.keys()[0]
		var radial:RadialMenu = _get_radial_by_name(&"upgrades_menu")
			
		if radial:
			if radial.is_visible(): radial.hide()
			var toget:StringName = &""
			match key:
				&"collector":
					toget = &"collector"
				&"generator":
					toget = &"generator"
				&"recycler":
					toget = &"recycler"
				_:
					pass
					
			if toget != &"":
				var item:UpgardeRadialItem = radial.get_item_by_id(toget)
				if item: item.show()


func _get_radial_by_id(id:StringName) -> RadialMenu:
	for each in radials:
		if each.data.id == id: return each
	return null
