extends Node2D # Senin en üstteki düğümün Node2D olduğu için böyle başlıyoruz

# 1. Parçaların canlarını tanımlıyoruz
var ust_can = 1
var orta_can = 1
var alt_can = 1

# 2. Fotoğraftaki isimlere göre parçaları koda tanıtıyoruz
# NOT: Fotoğraftaki isimlerinle birebir aynı yazdım.
@onready var ust_kat = $StaticBody2D2üst
@onready var orta_kat = $StaticBody2Dorta
@onready var alt_kat = $StaticBody2Dalt

# 3. Hasar alma fonksiyonu
func hasar_al():
	if ust_can > 0:
		ust_can -= 1
		ust_kat.queue_free() # En üst katı tamamen siler
		print("Üst kat yıkıldı!")
		
	elif orta_can > 0:
		orta_can -= 1
		orta_kat.queue_free() # Orta katı tamamen siler
		print("Orta kat yıkıldı!")
		
	elif alt_can > 0:
		alt_can -= 1
		alt_kat.queue_free() # Alt katı tamamen siler
		print("Kale yerle bir oldu!")

# TEST ETMEK İÇİN: Klavyeden Boşluk (Space) tuşuna basınca çalışır
func _input(event):
	if event.is_action_pressed("ui_accept"):
		hasar_al()
