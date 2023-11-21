extends Node2D


var _level = load("res://scenes/levels/" + Global.chosen_level + ".tscn")
var level
var _player = load("res://scenes/characters/" + Global.chosen_character + ".tscn")
var player
var rng = RandomNumberGenerator.new()
var mob_spawn_location

# Called when the node enters the scene tree for the first time.
func _ready():
	level = _level.instantiate()
	player = _player.instantiate()
	player.position = level.starting_position
	Global.player = player
	add_child(level)
	add_child(player)
	

func _spawn_mobs(amount):
	for i in range(amount):
		mob_spawn_location = player.get_node("MobSpawnPath/MobSpawnLocation")
		mob_spawn_location.progress_ratio = randf()
		mob_spawn_location.position.x += player.position.x
		mob_spawn_location.position.y += player.position.y
		var mob = level.available_mobs[0].instantiate()
		mob.position = mob_spawn_location.position
		add_child(mob)


func _on_mob_spawn_timer_timeout():
	_spawn_mobs(2)

