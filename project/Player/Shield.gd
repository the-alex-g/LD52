extends StaticBody2D

var health := 0
var _max_health := 0

onready var _tween : Tween = $Tween


func _ready()->void:
	_max_health = health
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color.white, 0.25, Tween.TRANS_QUAD)
	# warning-ignore:return_value_discarded
	_tween.start()


func hit(damage:int)->void:
	health -= abs(damage)
	
	if health <= 0:
		$CollisionPolygon2D.disabled = true
		# warning-ignore:return_value_discarded
		_tween.interpolate_property(self, "modulate", null, Color(1, 1, 1, 0), 0.5, Tween.TRANS_QUAD)
		# warning-ignore:return_value_discarded
		_tween.start()
		
		yield(_tween, "tween_all_completed")
		queue_free()
	
	else:
		# warning-ignore:return_value_discarded
		_tween.interpolate_property(self, "modulate", null, Color(1, 1, 1, lerp(0.5, 1.0, float(health) / _max_health)), 0.25, Tween.TRANS_QUAD)
		# warning-ignore:return_value_discarded
		_tween.start()


func _on_Timer_timeout():
	hit(1)
