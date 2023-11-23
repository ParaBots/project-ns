extends Area2D


@export var cooldown: int = 1
@export var damage: int = 3

var rng  = RandomNumberGenerator.new()

func activate()->void:
	var mob_to_hit = choose_mob_to_hit()
	if mob_to_hit != null:
		position = mob_to_hit.position
		show()
		mob_to_hit.lose_health(damage)

func choose_mob_to_hit()->CharacterBody2D:
	var mobs = get_overlapping_bodies()
	print(mobs)
	var mob_to_hit = null
	if mobs:
		while true:
			mob_to_hit = mobs.pick_random()
			if mob_to_hit.is_in_group("monsters"):
				break
	return mob_to_hit
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	$cooldown.wait_time = cooldown
	

func _on_cooldown_timeout():
	activate()
