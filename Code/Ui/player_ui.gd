class_name PlayerUi extends Control


const CREDITS:String = "uid://cnxisxk0u3g8s"
const SETTINGS:String = "uid://k6soqaiglr3s"
const HOWTO:String = "uid://b4dxqdfuynvhl"

const MESSAGETIMER:float = 5.0


@onready var star_material_label: Label = %star_material_label
@onready var star_material: Label = %star_material
@onready var speed_label: Label = %speed_label
@onready var speed_level: Label = %speed_level
@onready var coll_label: Label = %coll_label
@onready var collectors: Label = %collectors
@onready var gen_label: Label = %gen_label
@onready var generators: Label = %generators
@onready var recyc_label: Label = %recyc_label
@onready var recyclers: Label = %recyclers
@onready var message: Label = %message

var credits:Control = null
var settings:Control = null
var howto:Control = null
var active:StringName = &""
var can_upgrade:bool = false
var message_timer_active:bool = false
var message_timer:float = 0.0:
	set(value):
		message_timer = value
		if message_timer >= MESSAGETIMER:
			_hide_message()


func _input(event: InputEvent) -> void:
	if active != "" and event.is_action_pressed(&"pause"):
		Signals.ToggleUi.emit(active, false)
		get_viewport().set_input_as_handled()
	
	if event.is_action_pressed(&"+"):
		Signals.DebugAddMaterial.emit(100)


func _ready() -> void:
	Signals.CurrentMaterialUpdated.connect(_update_star_material)
	Signals.ToggleUi.connect(_toggle_ui)
	Signals.LevelUpgraded.connect(_check_unlocks)
	Signals.UpgradeAdded.connect(_upgrade_added)
	Signals.NotEnoughMaterial.connect(_not_enough_material)


func _process(delta: float) -> void:
	if message_timer_active: message_timer += delta


func _update_star_material(value:int) -> void:
	star_material.text = str(value)


func _toggle_ui(ui_id:StringName, display:bool) -> void:
	var to_toggle:Control
	print(ui_id)
	match ui_id:
		&"play_ui":
			if display: show()
			else: hide()
		&"credits":
			if credits == null:
				credits = load(CREDITS).instantiate()
				add_child(credits)
				credits.global_position.x = (180 - credits.size.x) / 2
				credits.global_position.y = (180 - credits.size.y) / 2
			to_toggle = credits
		&"settings":
			if settings == null:
				settings = load(SETTINGS).instantiate()
				add_child(settings)
				settings.global_position.x = (180 - settings.size.x) / 2
				settings.global_position.y = (180 - settings.size.y) / 2
			to_toggle = settings
		&"how_to":
			if howto == null:
				howto = load(HOWTO).instantiate()
				add_child(howto)
				howto.global_position.x = (180 - howto.size.x) / 2
				howto.global_position.y = (180 - howto.size.y) / 2
			to_toggle = howto
		_:
			pass
	
	if to_toggle != null:
		if display: 
			to_toggle.show()
			active = ui_id
		else: 
			to_toggle.hide()
			active = &""
	
	if not display and get_tree().paused: get_tree().paused = false


func _check_unlocks(level:int) -> void:
	var unlock:Dictionary = {}
	if Utilities.unlocks.has(level):
		unlock = Utilities.unlocks[level]
	
	if not unlock.is_empty():
		var key:StringName = unlock.keys()[0]
		var text:String = unlock[key]
		
		message.text = text
		_show_message()
		
		match key:
			&"speed":
				speed_label.show()
				speed_level.show()
			&"collector":
				coll_label.show()
				collectors.show()
				can_upgrade = true
			&"generator":
				gen_label.show()
				generators.show()
			&"recycler":
				recyc_label.show()
				recyclers.show()
			_:
				pass


func _upgrade_added(id:StringName, new_total:int) -> void:
	match id:
		&"speed":
			speed_level.text = str(new_total)
		&"collector":
			collectors.text = str(new_total)
		&"generator":
			generators.text = str(new_total)
		&"recycler":
			recyclers.text = str(new_total)
		_:
			pass


func _hide_message() -> void:
	if message_timer_active:
		message_timer_active = false
		message_timer = 0.0
		var tween:Tween = create_tween()
		tween.finished.connect(message.hide)
		tween.tween_property(message, "modulate", Color.TRANSPARENT, 1.5)


func _show_message() -> void:
	message_timer = 0.0
	message.modulate = Color.TRANSPARENT
	message.show()
	var tween:Tween = create_tween()
	tween.finished.connect(func():message_timer_active = true)
	tween.tween_property(message, "modulate", Color.WHITE, 1.5)


func _not_enough_material() -> void:
	var tween:Tween = create_tween()
	tween.tween_property(star_material_label, "modulate", Color.DARK_RED, 0.6)
	tween.tween_property(star_material_label, "modulate", Color.WHITE, 0.6)
	tween.tween_property(star_material_label, "modulate", Color.DARK_RED, 0.6)
	tween.tween_property(star_material_label, "modulate", Color.WHITE, 0.6)
