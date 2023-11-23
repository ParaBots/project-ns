extends CharacterBody2D


@export var health: int = 0
@export var max_health: int = 0
@export var shield: int = 0
@export var max_shield: int = 0
@export var speed: int = 0

var minutes_played: int = 0
var seconds_played: int = 0

var level: int = 1
var experience: int = 0
var experience_to_level_up: int = 3 * (ceil(float(level)/2) ) * (1 + (ceil(float(level)/2)))
var screen_size


func _ready():
	z_index = 2
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.play()
	_update_exp_label()
	$experience_bar.max_value = experience_to_level_up
	


func _update_exp_label():
	$experience_label.text = "Experience: " + str(experience) + " / " + str(experience_to_level_up)

func _level_up():
	level += 1
	experience = 0
	experience_to_level_up = 3 * (ceil(float(level)/2) + 1) * (1 + (ceil(float(level)/2) + 1))
	$level_label.text = "Lvl " + str(level)
	$experience_bar.max_value = experience_to_level_up

func die()->void:
	pass


func gain_experience(amount: int)->void:
	experience += amount
	if experience >= experience_to_level_up:
		_level_up()
	_update_exp_label()
	$experience_bar.value = experience


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


# signals
func _on_game_timer_timeout()->void:
	_update_timer()


func _update_timer()->void:
	seconds_played += 1
	if seconds_played == 60:
		minutes_played += 1
		seconds_played = 0
	_update_timer_label()


# can probably be done prettier for sure but w/e lol
func _update_timer_label()->void:
	var minutes
	var seconds
	
	if minutes_played < 10:
		minutes = "0" + str(minutes_played)
	else:
		minutes = str(minutes_played)
	
	if seconds_played < 10:
		seconds = "0" + str(seconds_played)
	else:
		seconds = str(seconds_played)
	$timer_label.text = minutes + ":" + seconds
