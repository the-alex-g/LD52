class_name MageAI
extends RootAI

export var magic_cooldown_time := 1.5

onready var _magic_cooldown_timer : Timer = $MagicCooldownTimer


func _ready()->void:
	._ready()
	_state = ActionState.STATIONARY
	_magic_cooldown_timer.wait_time = magic_cooldown_time


func _advance(delta:float)->void:
	._advance(delta)
	_process_magic_timer()


func _stationary()->void:
	._stationary()
	_process_magic_timer()


func _get_new_state()->void:
	if good:
		match randi() % 5:
			0,1,2,3:
				_state = ActionState.STATIONARY
			4:
				_state = ActionState.WANDER
	else:
		if target == null:
			_state = ActionState.WANDER
		else:
			_state = ActionState.STATIONARY


func _process_magic_timer()->void:
	if _is_target_in_range() and _magic_cooldown_timer.is_stopped() and target != null:
		_magic_cooldown_timer.start()
	if not _is_target_in_range() or target == null:
		_magic_cooldown_timer.stop()


func _on_MagicCooldownTimer_timeout()->void:
	if target != null:
		_shoot()
	else:
		_magic_cooldown_timer.stop()


func _shoot()->void:
	var bolt : Area2D
	if good:
		bolt = preload("res://Weapons/GoodBolt.tscn").instance()
	else:
		bolt = preload("res://Weapons/DarkBolt.tscn").instance()
	
	bolt.from = global_position
	bolt.to = target.global_position
	bolt.damage = _get_attack_damage()
	
	get_parent().add_child(bolt)
