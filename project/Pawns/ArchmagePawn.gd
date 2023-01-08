extends MageAI


func _set_good(value:bool)->void:
	if value and not good:
		$LightHalo.show()
	._set_good(value)
	if not good:
		$LightHalo.hide()

