class_name Player
extends KinematicBody2D

export var speed := 210.0
export var cooldown_time := 1.0
export var min_damage := 100
export var max_damage := 200

var _can_shoot := true
var good := false

onready var _cooldown_timer : Timer = $AttackCooldownTimer


func _physics_process(delta:float)->void:
	var direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
	#rotation = direction.angle()
	
	if Input.is_action_pressed("shoot") and _can_shoot:
		_shoot()
	
	# warning-ignore:return_value_discarded
	move_and_collide(direction * speed * delta)


func _shoot()->void:
	_can_shoot = false
	_cooldown_timer.start(cooldown_time)
	
	var bolt = preload("res://Weapons/DarkBolt.tscn").instance()
	bolt.to = get_global_mouse_position()
	bolt.from = global_position
	bolt.damage = lerp(max_damage, min_damage, 1 - PawnHandler.get_dark_strength())
	get_parent().add_child(bolt)
	
	yield(_cooldown_timer, "timeout")
	_can_shoot = true


func hit(damage:int)->void:
	print(damage)


func _draw()->void:
	draw_circle(Vector2.ZERO, 16, Color.black)
