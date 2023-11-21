extends Area2D

var colour: String
var exp_value: int


func _ready():
	$AnimatedSprite.animation = colour
	set_exp_value(exp_value)

# body can only be character body because of layer masks n shit
func _on_body_entered(body: CharacterBody2D)->void:
	hide()
	body.gain_experience(exp_value)
	queue_free()


func set_colour()->void:
	if exp_value <= 5:
		colour = "green"
	elif exp_value <= 15:
		colour = "blue"
	elif exp_value <= 25:
		colour = "red"
	elif exp_value <= 50:
		colour = "gold"
	else:
		colour = "green"


func set_exp_value(_exp_value: int)->void:
	exp_value = _exp_value
	set_colour()
