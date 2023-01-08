class_name Player
extends KinematicBody2D

export var speed := 210.0
export var cooldown_time := 1.0
export var shield_cooldown_time := 4.0
export var heal_cooldown_time := 4.0
export var min_damage := 7
export var max_damage := 20

var _can_shoot := true
var _can_create_shield := true
var _can_heal := true
var good := false

onready var _cooldown_timer : Timer = $AttackCooldownTimer
onready var _shield_timer : Timer = $ShieldCooldownTimer
onready var _heal_timer : Timer = $HealCooldownTimer
onready var _sprite : AnimatedSprite = $AnimatedSprite


func _physics_process(delta:float)->void:
	var direction := Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
	if direction != Vector2.ZERO:
		_sprite.play("Run")
		_sprite.rotation = direction.angle()
	else:
		_sprite.play("Idle")
	
	#rotation = direction.angle()
	
	if Input.is_action_pressed("shoot") and _can_shoot:
		_shoot()
	
	if Input.is_action_just_pressed("create_shield") and _can_create_shield:
		_create_shield()
	
	if Input.is_action_just_pressed("heal") and _can_heal:
		_heal()
	
	# warning-ignore:return_value_discarded
	move_and_collide(direction * speed * delta)


func _shoot()->void:
	_can_shoot = false
	_cooldown_timer.start(cooldown_time)
	
	var target_position := global_position + (Vector2.RIGHT * 200).rotated(get_global_mouse_position().angle_to_point(global_position))
	
	var bolt = preload("res://Weapons/DarkBolt.tscn").instance()
	bolt.to = target_position
	bolt.from = global_position
	bolt.damage = lerp(max_damage, min_damage, 1 - PawnHandler.get_dark_strength())
	get_parent().add_child(bolt)
	
	yield(_cooldown_timer, "timeout")
	_can_shoot = true


func _create_shield()->void:
	_can_create_shield = false
	_shield_timer.start(shield_cooldown_time)
	
	var shield = preload("res://Player/Shield.tscn").instance()
	shield.health = lerp(min_damage, max_damage, PawnHandler.get_dark_strength()) * 2
	shield.position = global_position
	shield.rotation = get_angle_to(get_global_mouse_position()) + PI / 2
	get_parent().add_child(shield)
	
	yield(_shield_timer, "timeout")
	_can_create_shield = true


func _heal()->void:
	_can_heal = false
	_heal_timer.start(heal_cooldown_time)
	PawnHandler.heal()
	yield(_heal_timer, "timeout")
	_can_heal = true


func hit(damage:int)->void:
	PawnHandler.player_health -= damage
	$HitSound.play()
