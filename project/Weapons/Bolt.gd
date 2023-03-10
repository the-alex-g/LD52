extends Area2D

export var bolt_color : Color

var from : Vector2
var damage : int
var to : Vector2
var finished := false

onready var _target_region : CollisionShape2D = $TargetRegion
onready var _tween : Tween = $Tween


func _ready()->void:
	var intersection := get_world_2d().direct_space_state.intersect_ray(from, to)
	
	if intersection.size() > 0:
		to = intersection.position
	_target_region.position = to
	$ExplosionParticles.position = to
	
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "to", from, _target_region.position, 0.09, Tween.TRANS_QUAD)
	# warning-ignore:return_value_discarded
	_tween.start()
	yield(_tween, "tween_all_completed")
	
	for body in get_overlapping_bodies():
		if body.has_method("hit"):
			body.hit(damage)
	$ExplosionSound.play()
	
	$ExplosionParticles.emitting = true
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(self, "from", null, to, 0.11, Tween.TRANS_QUAD)
	# warning-ignore:return_value_discarded
	_tween.start()
	yield(_tween, "tween_all_completed")
	
	finished = true


func _process(_delta:float)->void:
	update()
	if not $ExplosionParticles.emitting and finished:
		queue_free()


func _draw()->void:
	draw_line(from, to, Color.black, 4.0)
	draw_line(from, to, bolt_color, 3.0)
