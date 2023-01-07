extends Node2D

onready var _player := $Player
onready var _enemy_container : Node2D = $Enemies
onready var _path_follow : PathFollow2D = $StandardSpawnPath/PathFollow2D
onready var _standard_spawn_point : Position2D = $StandardSpawnPath/PathFollow2D/StandardSpawnPoint


func _ready()->void:
	randomize()
	
	for _i in 64:
		_path_follow.unit_offset = randf()
		_path_follow.rotation = randf() * TAU
		var pawn = preload("res://Pawns/StandardPawn.tscn").instance()
		pawn.position = _standard_spawn_point.global_position
		_enemy_container.add_child(pawn)
