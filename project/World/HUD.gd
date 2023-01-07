extends CanvasLayer

onready var _victory_progress : ProgressBar = $ProgressBar


func _ready()->void:
	_victory_progress.max_value = PawnHandler.max_strength


func _process(_delta:float)->void:
	_victory_progress.value = PawnHandler.dark_strength
