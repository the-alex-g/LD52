class_name VariableStreamPlayer
extends AudioStreamPlayer2D

export var pitch_variance := 0.1
export var volume_variance := 1.0

var _original_volume := 0.0
var _original_pitch := 0.0

func _ready()->void:
	_original_pitch = pitch_scale
	_original_volume = volume_db


func play(from:=0.0)->void:
	pitch_scale = _original_pitch + max(0.0, lerp(-pitch_variance, pitch_variance, randf()))
	volume_db = _original_volume + lerp(-volume_variance, volume_variance, randf())
	.play()
