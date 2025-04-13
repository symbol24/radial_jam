class_name Settings extends Control


@onready var master_volume: HSlider = %master_volume
@onready var music_volume: HSlider = %music_volume
@onready var sfx_volume: HSlider = %sfx_volume
@onready var bnt_fullscreen: Button = %bnt_fullscreen
@onready var btn_back: TextureButton = %btn_back

var full_on:bool = false


func _ready() -> void:
	master_volume.value_changed.connect(_master_volume_value_changed)
	music_volume.value_changed.connect(_music_volume_value_changed)
	sfx_volume.value_changed.connect(_sfx_volume_value_changed)
	visibility_changed.connect(_visibility_changed)
	bnt_fullscreen.pressed.connect(_btn_fullscreen_pressed)
	btn_back.pressed.connect(_btn_back_pressed)
	_set_sliders()
	master_volume.grab_focus()


func _master_volume_value_changed(value) -> void:
	Audio.BusVolumeUpdate.emit("Master", value)


func _music_volume_value_changed(value) -> void:
	Audio.BusVolumeUpdate.emit("Music", value)


func _sfx_volume_value_changed(value) -> void:
	Audio.BusVolumeUpdate.emit("SFX", value)


func _btn_fullscreen_pressed() -> void:
	if full_on:
		bnt_fullscreen.text = "OFF"
		full_on = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		bnt_fullscreen.text = "ON"
		full_on = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _visibility_changed() -> void:
	_set_sliders()
	master_volume.grab_focus()


func _set_sliders() -> void:
	master_volume.value = AudioServer.get_bus_volume_linear(0)
	music_volume.value = AudioServer.get_bus_volume_linear(1)
	sfx_volume.value = AudioServer.get_bus_volume_linear(2)


func _btn_back_pressed() -> void:
	Signals.ToggleUi.emit(&"credits", false)
