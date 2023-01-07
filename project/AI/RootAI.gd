class_name RootAI
extends KinematicBody2D

enum ActionState {STATIONARY, ADVANCE, FLEE, WANDER}

export var speed := 150.0
export var sense_range := 500.0
export var attack_cooldown_time := 1.5
export var attack_damage := 1 setget , _get_attack_damage
export var health := 9
export var armor := 0
export var strength := 1

var _state = ActionState.WANDER
var target : Node2D
var player : Node2D
export var good := true setget _set_good

onready var _cooldown_timer : Timer = $AttackCooldownTimer
onready var _attack_area : Area2D = $AttackArea


func _ready()->void:
	_cooldown_timer.wait_time = attack_cooldown_time
	_set_good(good)


func _physics_process(delta:float)->void:
	match _state:
		ActionState.STATIONARY:
			_stationary()
		ActionState.ADVANCE:
			_advance(delta)
		ActionState.FLEE:
			_flee(delta)
		ActionState.WANDER:
			_wander(delta)
	update()
	
	if target != null:
		if target.good == good:
			_get_new_target()


func _stationary()->void:
	_point_towards_target()


func _wander(delta:float)->void:
	rotation += lerp(-0.15, 0.15, randf())
	# delta / 2 halves speed
	_move(delta / 2)


func _advance(delta:float)->void:
	_point_towards_target()
	if _is_target_in_range():
		_move(delta)


func _flee(delta:float)->void:
	_point_towards_target()
	if _is_target_in_range():
		rotation += PI
		_move(delta * 0.9)


func _point_towards_target()->void:
	rotation = _get_angle_to_target()


func _move(delta)->void:
	var direction := Vector2.RIGHT.rotated(rotation)
	# warning-ignore:return_value_discarded
	move_and_collide(direction * speed * delta)


func _get_angle_to_target()->float:
	if target != null:
		return target.global_position.angle_to_point(global_position)
	return 0.0


func _is_target_in_range()->bool:
	if target != null:
		return pow(sense_range, 2) >= global_position.distance_squared_to(target.global_position)
	return false


func _on_AttackArea_body_entered(_body:Node2D)->void:
	# if the attack timer is not started, start it
	_cooldown_timer.start(attack_cooldown_time / (2 if good else 1))


func _on_AttackArea_body_exited(_body:Node2D)->void:
	# if there are no enemies left in the area, stop the timer
	if _attack_area.get_overlapping_bodies().size() == 0:
		_cooldown_timer.stop()


func _on_AttackCooldownTimer_timeout()->void:
	for body in _attack_area.get_overlapping_bodies():
		body.hit(_get_attack_damage())
		target = null
		_get_new_target()


func _on_PawnSenseArea_body_entered(_body:Node2D)->void:
	_get_new_target()


func _set_good(value:bool)->void:
	good = value
	
	_get_new_target()
	
	set_collision_layer_bit(1, good)
	set_collision_layer_bit(2, not good)
	# this is strange. It wouldn't work with the _attack_area variable.
	$AttackArea.set_collision_mask_bit(1, not good)
	$AttackArea.set_collision_mask_bit(2, good)
	$AttackArea.set_collision_mask_bit(3, good)
	
	$PawnSenseArea.set_collision_mask_bit(1, not good)
	$PawnSenseArea.set_collision_mask_bit(2, good)
	$PawnSenseArea.set_collision_mask_bit(3, good)


func hit(damage:int)->void:
	# warning-ignore:narrowing_conversion
	damage = max(1, damage - armor) * (1 if good else -1)
	health -= damage
	
	if health <= 0 and good:
		PawnHandler.dark_strength += strength
		if target is Player:
			target = null
		_set_good(false)
	
	elif health > 0 and not good:
		PawnHandler.dark_strength -= strength
		_set_good(true)


func _get_new_state()->void:
	if good:
		match randi() % 3:
			0:
				_state = ActionState.FLEE
			1:
				_state = ActionState.ADVANCE
			2:
				_state = ActionState.WANDER
	else:
		if target != null:
			_state = ActionState.ADVANCE
		else:
			_state = ActionState.WANDER


func _get_new_target()->void:
	var nearby_bodies : Array = $PawnSenseArea.get_overlapping_bodies()
	
	if nearby_bodies.size() > 0:
		var viable_bodies := []
		for body in nearby_bodies:
			if body.good != good:
				viable_bodies.append(body)
		
		if viable_bodies.size() > 0:
			var new_target : Node2D = nearby_bodies[0]
			
			for body in viable_bodies:
				if global_position.distance_squared_to(body.global_position) < global_position.distance_squared_to(new_target.global_position):
					new_target = body
		
			target = new_target
		
		else:
			target = null
	else:
		target = null
	
	_get_new_state()


func _get_attack_damage()->int:
	if good:
		return lerp(attack_damage, attack_damage * 2, 1.0 - PawnHandler.get_dark_strength())
	return lerp(attack_damage, attack_damage * 2, PawnHandler.get_dark_strength())


func _draw()->void:
	draw_circle(Vector2.ZERO, 16, Color.blue if good else Color.red)
