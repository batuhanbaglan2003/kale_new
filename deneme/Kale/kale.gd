extends Node2D

@export var parca_ust: Sprite2D    # 1. Resim (Çatı)
@export var parca_orta: Sprite2D   # 2. Resim (Gövde)
@export var parca_alt: Sprite2D    # 3. Resim (Temel)

var can = 4

func take_damage(_amount):
	if can == 3:
		if parca_ust: parca_ust.queue_free()
		print("Kale: Çatı uçtu!")
	elif can == 2:
		if parca_orta: parca_orta.queue_free()
		print("Kale: Orta kat yıkıldı!")
	elif can == 1:
		if parca_alt: parca_alt.queue_free()
		print("Kale: Tamamen bitti!")
		queue_free() # Kale yok olunca main_scene "Oyun Bitti" diyecek
	can -= 1
