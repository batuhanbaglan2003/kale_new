extends StaticBody2D

var top_health = 1
var mid_health = 1
var bottom_health = 1

# Sahne ağacındaki düğüm isimlerinin bunlarla AYNI olması lazım!
@onready var top_part = $TopPart
@onready var mid_part = $MidPart
@onready var bottom_part = $BottomPart

func take_damage(amount): # 'amount' parametresini ekledik
	if top_health > 0:
		top_health -= 1
		if top_part: top_part.queue_free()
		print("Kale: Üst parça düştü!")
	elif mid_health > 0:
		mid_health -= 1
		if mid_part: mid_part.queue_free()
		print("Kale: Orta parça düştü!")
	elif bottom_health > 0:
		bottom_health -= 1
		if bottom_part: bottom_part.queue_free()
		print("Kale: Yıkıldı!")
