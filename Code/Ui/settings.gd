class_name Settings extends Control


@onready var music_volume: HSlider = %music_volume
@onready var sfx_volume: HSlider = %sfx_volume
@onready var btn_back: TextureButton = %btn_back
@onready var border: NinePatchRect = %border

var full_on:bool = false


func _ready() -> void:
	music_volume.value_changed.connect(_music_volume_value_changed)
	sfx_volume.value_changed.connect(_sfx_volume_value_changed)
	visibility_changed.connect(_visibility_changed)
	btn_back.pressed.connect(_btn_back_pressed)
	btn_back.focus_entered.connect(_on_btn_focus_changed)
	btn_back.focus_exited.connect(_on_btn_focus_changed)
	_set_sliders()
	music_volume.grab_focus()


func _music_volume_value_changed(value) -> void:
	Audio.BusVolumeUpdate.emit("Music", value)


func _sfx_volume_value_changed(value) -> void:
	Audio.BusVolumeUpdate.emit("SFX", value)


func _visibility_changed() -> void:
	_set_sliders()
	music_volume.grab_focus()


func _set_sliders() -> void:
	music_volume.value = AudioServer.get_bus_volume_linear(1)
	sfx_volume.value = AudioServer.get_bus_volume_linear(2)


func _btn_back_pressed() -> void:
	Signals.ToggleUi.emit(&"settings", false)


func _on_btn_focus_changed() -> void:
	if btn_back.has_focus(): border.show()
	else: border.hide()
