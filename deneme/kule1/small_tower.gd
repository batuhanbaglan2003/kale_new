extends StaticBody2D

var health = 2

func take_damage(amount):
	health -= 2
	if health <= 0:
		print("Küçük kule yok oldu!")
		queue_free()
