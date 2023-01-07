extends CanvasLayer

onready var _victory_progress : ProgressBar = $ProgressBar


func _ready()->void:
	_victory_progress.max_value = PawnHandler.max_strength


func _process(_delta:float)->void:
	_victory_progress.value = PawnHandler.dark_strength
	if PawnHandler.dark_strength == PawnHandler.max_strength and not $EndGamePanel.visible:
		$EndGamePanel.show()
		get_tree().paused = true


func _on_Button_pressed()->void:
	get_tree().paused = false
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")


func _on_MainMenu_pressed()->void:
	get_tree().paused = false
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menu/MainMenu.tscn")
