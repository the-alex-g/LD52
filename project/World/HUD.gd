extends CanvasLayer

onready var _victory_progress : ProgressBar = $ProgressBar
onready var _endgame_label : Label = $EndGamePanel/VBoxContainer/Label
onready var _endgame_panel : Panel = $EndGamePanel
onready var _health_bar : ProgressBar = $PlayerHealth

var _game_over := false


func _ready()->void:
	_victory_progress.max_value = PawnHandler.max_strength
	_health_bar.max_value = PawnHandler.player_health


func _process(_delta:float)->void:
	_victory_progress.value = PawnHandler.dark_strength
	_health_bar.value = PawnHandler.player_health
	
	_check_for_endgame()
	

func _check_for_endgame()->void:
	if PawnHandler.dark_strength == PawnHandler.max_strength and not _game_over:
		_resolve_endgame("You win! \nYou have harvested the intelligence of all the Grey Folk!")
	if PawnHandler.player_health <= 0 and not _game_over:
		_resolve_endgame("You lose! \nThe Grey Folk have chased you out of their settlement.")


func _resolve_endgame(message:String)->void:
	_game_over = true
	_endgame_panel.show()
	_endgame_label.text = message
	PawnHandler.reset()
	get_tree().paused = true


func _on_Button_pressed()->void:
	get_tree().paused = false
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")


func _on_MainMenu_pressed()->void:
	get_tree().paused = false
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menu/MainMenu.tscn")
