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
	player_cannon.is_active = false # Girişte ateş edemesin
	bot_cannon.side = "Right"
	if result_label != null: result_label.hide()
	
	# 🎬 GİRİŞ SİNEMATİĞİ (3 Saniye)
	if kamera != null:
		kamera.target_node = null # Kamerayı serbest bırak (Geniş plan)
	
	await get_tree().create_timer(3.0).timeout
	
	# Giriş bitti, oyuncuya geç
	if kamera != null: kamera.odaklan(player_cannon)
	player_cannon.is_active = true

func _process(_delta):
	if oyun_bitti: return
	if not is_instance_valid(bot_kale): oyunu_sonlandir("KAZANDINIZ!"); return
	if not is_instance_valid(player_kale): oyunu_sonlandir("KAYBETTİNİZ..."); return

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
				# 🎥 Atış sonrası 1 saniye bekleme
				await get_tree().create_timer(1.0).timeout
				sira = "PLAYER"
				if kamera != null: kamera.odaklan(player_cannon)
				player_cannon.is_active = true

func bot_hamlesi():
	if oyun_bitti: return
	
	# 🤖 BOT ATIŞ ÖNCESİ BEKLEME (1.5 Saniye)
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
	
	var bot_gucu = mukemmel_guc + (randf_range(-8.0, 8.0) * bot_hata_carpan)
	bot_gucu = clamp(bot_gucu, 0.0, 100.0)
	bot_hata_carpan = max(0.1, bot_hata_carpan - 0.3)
	
	bot_cannon.bot_fire(deg_to_rad(-120), bot_gucu)

func oyunu_sonlandir(mesaj):
	oyun_bitti = true
	if result_label != null:
		result_label.text = mesaj
		result_label.show()
	player_cannon.is_active = false
	bot_cannon.is_active = false
