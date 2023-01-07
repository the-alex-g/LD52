extends MageAI


func _set_good(value:bool)->void:
	._set_good(value)
	if not good:
		$LightHalo.hide()

