extends Area2D

var speed = Vector2(700,-900)
var gravity_force = 1800

func _process(delta):
	speed.y += gravity_force*delta
	
	position += delta*speed
	
	rotation = speed.angle()
