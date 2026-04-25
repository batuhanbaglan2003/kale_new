extends StaticBody2D

var health = 1

func take_damage():
	health -= 1
	if health <= 0:
		queue_free() # Sadece bu kule yıkılır
		print("Bir küçük kule yıkıldı!")
