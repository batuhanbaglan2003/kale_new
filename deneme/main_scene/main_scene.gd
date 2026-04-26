extends Node2D

@onready var player_cannon = $PlayerCannon
@onready var bot_cannon = $BotCannon
@onready var player_kale = $PlayerKale
@onready var bot_kale = $BotKale
@onready var player_on_kule = $PlayerOnKule
@onready var bot_on_kule = $BotOnKule
@onready var result_label = $UI/ResultLabel
@onready var kamera = $Kamera

var sira = "PLAYER" 
var oyun_bitti = false
var bot_hedef_ismi = ""
var bot_hata_carpan = 1.0

func _ready():
	# Resimleri artık editörden koyduğun için _temalari_yukle fonksiyonunu kaldırdık.
	
	player_cannon.is_active = false 
	bot_cannon.side = "Right"
	if result_label != null: result_label.hide()
	
	if kamera != null:
		kamera.target_node = null 
	
	# Başlangıçta 3 saniye bekle
	await get_tree().create_timer(3.0).timeout
	
	# Kamera oyuncuya odaklansın ve kontrol açılsın
	if kamera != null: kamera.odaklan(player_cannon)
	player_cannon.is_active = true

func _process(_delta):
	if oyun_bitti: return

	# 1. Kazanma/Kaybetme Kontrolü
	var bot_tamamen_yikildi = !is_instance_valid(bot_kale) and !is_instance_valid(bot_on_kule)
	if bot_tamamen_yikildi:
		oyunu_sonlandir("KAZANDINIZ!")
		return

	var player_tamamen_yikildi = !is_instance_valid(player_kale) and !is_instance_valid(player_on_kule)
	if player_tamamen_yikildi:
		oyunu_sonlandir("KAYBETTİNİZ...")
		return

	# 2. Sıra Yönetimi
	var mermiler = get_tree().get_nodes_in_group("mermiler")
	var mermi_sayisi = mermiler.size()
	
	match sira:
		"PLAYER":
			if mermi_sayisi > 0:
				sira = "WAIT_BOT"
				player_cannon.is_active = false
		"WAIT_BOT":
			if mermi_sayisi == 0:
				sira = "BOT"
				if kamera != null: kamera.odaklan(bot_cannon)
				bot_hamlesi()
		"BOT":
			if mermi_sayisi > 0: sira = "WAIT_PLAYER"
		"WAIT_PLAYER":
			if mermi_sayisi == 0:
				await get_tree().create_timer(1.0).timeout
				sira = "PLAYER"
				if kamera != null: kamera.odaklan(player_cannon)
				player_cannon.is_active = true

# Botun Akıllı Ateş Etme Mantığı
func bot_hamlesi():
	if oyun_bitti: return
	await get_tree().create_timer(1.5).timeout 
	
	var hedef = null
	if is_instance_valid(player_on_kule): hedef = player_on_kule
	elif is_instance_valid(player_kale): hedef = player_kale
	else: hedef = player_cannon
		
	if hedef.name != bot_hedef_ismi:
		bot_hedef_ismi = hedef.name
		bot_hata_carpan = 1.0

	var mesafe_x = abs(bot_cannon.global_position.x - hedef.global_position.x)
	var gerekli_hiz = sqrt((mesafe_x * 600.0) / 0.866)
	var mukemmel_guc = gerekli_hiz / 10.0
	
	var bot_gucu = clamp(mukemmel_guc + (randf_range(-8.0, 8.0) * bot_hata_carpan), 0.0, 100.0)
	bot_hata_carpan = max(0.1, bot_hata_carpan - 0.3)
	
	bot_cannon.bot_fire(deg_to_rad(-120), bot_gucu)

func oyunu_sonlandir(mesaj):
	oyun_bitti = true
	if result_label != null:
		result_label.text = mesaj
		result_label.show()
	player_cannon.is_active = false
	bot_cannon.is_active = false
