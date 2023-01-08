extends RootAI


func _get_good_state():
	match randi() % 5:
		0, 1, 2, 3:
			_state = ActionState.ADVANCE
		4:
			_state = ActionState.STATIONARY
