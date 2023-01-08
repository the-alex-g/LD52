extends Node

onready var main_loop : AudioStreamPlayer = $MainLoop
onready var menu_loop : AudioStreamPlayer = $MenuLoop


func play_menu()->void:
	main_loop.stop()
	menu_loop.play()


func play_main()->void:
	main_loop.play()
	menu_loop.stop()
