extends Node

signal release_pawn

var dark_strength := 0
var max_strength := 144
var player_health := 50


func get_dark_strength()->float:
	return (float(dark_strength) / max_strength)


func reset()->void:
	dark_strength = 0
	player_health = 50


func heal()->void:
	emit_signal("release_pawn")
	player_health += 10
