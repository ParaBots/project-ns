extends CharacterBody2D


@export var health: int = 0
@export var max_health: int = 0
@export var shield: int = 0
@export var max_shield: int = 0
@export var speed: int = 0

var experience: int = 0
var screen_size


func _ready():
	z_index = 2
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play()


func die()->void:
	pass


func gain_experience(amount: int)->void:
	experience += amount
	print("Current exp: " + str(experience))


func gain_health(amount: int)->void:
	if (health + amount) > max_health:
		health = max_health
	else:
		health += amount


func gain_shield(amount: int)->void:
	if (shield + amount) > max_shield:
		shield = max_shield
	else:
		shield += amount


func get_input():
	position = position.clamp(Vector2.ZERO, screen_size)
	$AnimatedSprite2D.play()
	velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
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
	var leftover = 0
	if shield > 0:
		shield -= amount
		if shield < 0:
			leftover = shield * (-1)
	
	health -= amount + leftover
	if health < max_health:
		die()


func use_ability()->void:
	pass


func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
