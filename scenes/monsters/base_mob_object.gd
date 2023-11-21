extends CharacterBody2D


@export var health: int = 0
@export var max_health: int = 0
@export var damage: int = 0
@export var ability_damage: int = 0
@export var speed: int = 0
@export var exp_drop_amount: int = 0

var screen_size
var basic_attack_on_cooldown: bool = false
var _exp_orb = preload("res://scenes/items/experience_orb.tscn")

func _ready():
	z_index = 1
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play()


func attack_player()->void:
	Global.player.lose_health(damage)
	basic_attack_on_cooldown = true
	$basic_attack_cooldown.start()


func die()->void:
	drop_exp()
	hide()
	queue_free()


func drop_exp()->void:
	var exp_orb = _exp_orb.instantiate()
	exp_orb.set_exp_value(exp_drop_amount)
	exp_orb.position = position
	get_node("/root/game").add_child(exp_orb)


func gain_health(amount: int)->void:
	if (health + amount) > max_health:
		health = max_health
	else:
		health += amount


func handle_animation()->void:
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.animation = "walk"
		if velocity.y != 0 and velocity.x == 0:
			# stop the sprite from snapping back to facing right if only up or down is being pressed
			pass
		else:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "idle"


func lose_health(amount: int)->void:
	health -= amount
	if health < max_health:
		die()


func move(delta)->void:
	position = position.clamp(Vector2.ZERO, screen_size)
	velocity = position.direction_to(Global.player.position) * speed
	handle_animation()
	if position.distance_to(Global.player.position) > 2:
			move_and_collide(velocity * delta)


func use_ability()->void:
	pass


func _physics_process(delta):
	move(delta)
	
	# SHOULD only ever be the player, because of layers/masks
	if not basic_attack_on_cooldown:
		var overlapping_bodies = $Area2D.get_overlapping_bodies()
		if overlapping_bodies.size() > 0:
			attack_player()


# signals
func _on_basic_attack_cooldown_timeout()->void:
	basic_attack_on_cooldown = false

