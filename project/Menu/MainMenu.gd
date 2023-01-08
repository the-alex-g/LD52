extends Control

var _sfx_bus := -1
var _music_bus := -1

onready var _sfx_slider : HSlider = $VBoxContainer/SFXSlider
onready var _music_slider : HSlider = $VBoxContainer/MusicSlider


func _ready()->void:
	Jukebox.play_menu()
	
	_sfx_bus = AudioServer.get_bus_index("SFX")
	_music_bus = AudioServer.get_bus_index("Music")
	
	$VBoxContainer/Fullscreen.pressed = OS.window_fullscreen
	if AudioServer.is_bus_mute(_sfx_bus):
		_sfx_slider.value = _sfx_slider.min_value
	else:
		_sfx_slider.value = AudioServer.get_bus_volume_db(_sfx_bus)
	
	if AudioServer.is_bus_mute(_music_bus):
		_music_slider.value = _music_slider.min_value
	else:
		_music_slider.value = AudioServer.get_bus_volume_db(_music_bus)

func _on_Play_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")


func _on_Fullscreen_toggled(button_pressed:bool)->void:
	OS.window_fullscreen = button_pressed


func _on_SFXSlider_value_changed(value:float)->void:
	if value == _sfx_slider.min_value:
		AudioServer.set_bus_mute(_sfx_bus, true)
	elif AudioServer.is_bus_mute(_sfx_bus):
		AudioServer.set_bus_mute(_sfx_bus, false)
	AudioServer.set_bus_volume_db(_sfx_bus, value)


func _on_MusicSlider_value_changed(value:float)->void:
	if value == _music_slider.min_value:
		AudioServer.set_bus_mute(_music_bus, true)
	elif AudioServer.is_bus_mute(_music_bus):
		AudioServer.set_bus_mute(_music_bus, false)
	AudioServer.set_bus_volume_db(_music_bus, value)
