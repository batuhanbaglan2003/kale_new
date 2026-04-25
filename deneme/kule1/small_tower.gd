extends StaticBody2D

var health = 1

func take_damage(amount):
	health -= 1
	if health <= 0:
		print("Küçük kule yok oldu!")
		queue_free()
