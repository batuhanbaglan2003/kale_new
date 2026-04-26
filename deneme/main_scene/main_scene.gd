extends Node2D

@onready var player_cannon = $PlayerCannon
@onready var bot_cannon = $BotCannon
@onready var player_kale = $PlayerKale
@onready var bot_kale = $BotKale
@onready var player_on_kule = $PlayerOnKule
@onready var bot_on_kule = $BotOnKule
@onready var result_label = $UI/ResultLabel
@onready var kamera = $Kamera

var tema_isimleri = ["tema1", "tema2", "tema3"]
var sira = "PLAYER" 
var oyun_bitti = false
var bot_hedef_ismi = ""
var bot_hata_carpan = 1.0

func _ready():
	# 1. Önce temaları yükle
	_temalari_yukle()
	
	# 2. Başlangıç ayarları
	player_cannon.is_active = false 
	bot_cannon.side = "Right"
	if result_label != null: result_label.hide()
	
	if kamera != null:
		kamera.target_node = null 
	
	# 3. Kısa bir bekleme ve başla
	await get_tree().create_timer(3.0).timeout
	
	if kamera != null: kamera.odaklan(player_cannon)
	player_cannon.is_active = true

func _process(_delta):
	if oyun_bitti: return

	# Kazanma/Kaybetme Kontrolü
	var bot_tamamen_yikildi = !is_instance_valid(bot_kale) and !is_instance_valid(bot_on_kule)
	if bot_tamamen_yikildi:
		oyunu_sonlandir("KAZANDINIZ!")
		return

	var player_tamamen_yikildi = !is_instance_valid(player_kale) and !is_instance_valid(player_on_kule)
	if player_tamamen_yikildi:
		oyunu_sonlandir("KAYBETTİNİZ...")
		return

	# Sıra Yönetimi
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

# --- TEMA YÜKLEME SİSTEMİ ---
func _temalari_yukle():
	var p_data = Global.temalar[Global.oyuncu_temasi]
	var b_data = Global.temalar[Global.bot_temasi]
	
	# OYUNCU KALESİ
	if is_instance_valid(player_kale):
		player_kale.parca_ust = _resim_yukle(p_data["kale"][0])
		player_kale.parca_orta = _resim_yukle(p_data["kale"][1])
		player_kale.parca_alt = _resim_yukle(p_data["kale"][2])
	
	# BOT KALESİ
	if is_instance_valid(bot_kale):
		bot_kale.parca_ust = _resim_yukle(b_data["kale"][0])
		bot_kale.parca_orta = _resim_yukle(b_data["kale"][1])
		bot_kale.parca_alt = _resim_yukle(b_data["kale"][2])
	
	# Kule ve Toplar
	if player_on_kule: player_on_kule.texture = _resim_yukle(p_data["kule"][0])
	if player_cannon: player_cannon.texture = _resim_yukle(p_data["top"])
	if bot_on_kule: bot_on_kule.texture = _resim_yukle(b_data["kule"][0])
	if bot_cannon: bot_cannon.texture = _resim_yukle(b_data["top"])

# YARDIMCI FONKSİYON: Dosya yoksa oyunu çökertmez, hangi dosya eksikse söyler.
func _resim_yukle(yol: String):
	if FileAccess.file_exists(yol):
		return load(yol)
	else:
		print("!!! HATA: Dosya bulunamadı -> ", yol)
		return null # Veya buraya varsayılan bir 'error.png' koyabilirsin
