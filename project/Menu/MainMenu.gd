extends Control

var _sfx_bus := -1
var _music_bus := -1


func _ready()->void:
	_sfx_bus = AudioServer.get_bus_index("SFX")
	_music_bus = AudioServer.get_bus_index("Music")
	$VBoxContainer/Fullscreen.pressed = OS.window_fullscreen
	$VBoxContainer/SFXMute.pressed = AudioServer.is_bus_mute(_sfx_bus)
	$VBoxContainer/MusicMute.pressed = AudioServer.is_bus_mute(_music_bus)

func _on_Play_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")


func _on_Fullscreen_toggled(button_pressed:bool)->void:
	OS.window_fullscreen = button_pressed


func _on_MusicMute_toggled(button_pressed:bool)->void:
	AudioServer.set_bus_mute(_music_bus, button_pressed)


func _on_SFXMute_toggled(button_pressed:bool)->void:
	AudioServer.set_bus_mute(_sfx_bus, button_pressed)
