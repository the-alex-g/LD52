extends Node

var dark_strength := 0
var max_strength := 144


func get_dark_strength()->float:
	return pow(float(dark_strength) / max_strength, 2)
