extends Node2D

@export var parca_ust: Sprite2D  # 1. Resim (Üst)
@export var parca_alt: Sprite2D  # 2. Resim (Alt)

var can = 3

func take_damage(_amount):
	if can == 2:
		if parca_ust: parca_ust.queue_free()
		print("Kule: Üst parça düştü!")
	elif can == 1:
		if parca_alt: parca_alt.queue_free()
		print("Kule: Yıkıldı!")
		queue_free() 
	can -= 1
