extends Node2D

@onready var player_cannon = $PlayerCannon
@onready var bot_cannon = $BotCannon
@onready var player_kale = $PlayerKale
@onready var bot_kale = $BotKale
@onready var player_on_kule = $PlayerOnKule
@onready var bot_on_kule = $BotOnKule
@onready var kamera = $Kamera

# UI kontrolü için güvenli yol
@onready var result_label = get_node_or_null("UI/ResultLabel") 

var sira = "PLAYER" 
var oyun_bitti = false
var bot_hedef_ismi = ""
var bot_hata_carpan = 1.0

func _ready():
	# Oyun başında yazıyı gizle (Eğer varsa)
	if result_label:
		result_label.hide()
	
	_temalari_uygula()
	
	if player_cannon: player_cannon.is_active = false 
	if bot_cannon: bot_cannon.side = "Right"
	
	# Kamera ayarları
	if kamera:
		kamera.zoom = Vector2(0.5, 0.5)
	
	await get_tree().create_timer(2.0).timeout
	if kamera and player_cannon: 
		kamera.odaklan(player_cannon)
		player_cannon.is_active = true

func _process(_delta):
	if oyun_bitti: return

	# Kazanma/Kaybetme Kontrolü (Düğümlerin varlığını kontrol eder)
	var p_hayatta = is_instance_valid(player_kale) or is_instance_valid(player_on_kule)
	var b_hayatta = is_instance_valid(bot_kale) or is_instance_valid(bot_on_kule)

	if not b_hayatta:
		oyunu_sonlandir("WIN")
		return

	if not p_hayatta:
		oyunu_sonlandir("LOSE")
		return

	_sira_yonetimi()

func _sira_yonetimi():
	var m_sayisi = get_tree().get_nodes_in_group("mermiler").size()
	
	match sira:
		"PLAYER":
			if m_sayisi > 0:
				sira = "WAIT_BOT"
				if player_cannon: player_cannon.is_active = false
		"WAIT_BOT":
			if m_sayisi == 0:
				sira = "BOT"
				if kamera and bot_cannon: kamera.odaklan(bot_cannon)
				bot_hamlesi()
		"BOT":
			if m_sayisi > 0: sira = "WAIT_PLAYER"
		"WAIT_PLAYER":
			if m_sayisi == 0:
				await get_tree().create_timer(1.0).timeout
				sira = "PLAYER"
				if kamera and player_cannon: 
					kamera.odaklan(player_cannon)
					player_cannon.is_active = true

func oyunu_sonlandir(mesaj):
	if oyun_bitti: return
	oyun_bitti = true
	
	if result_label:
		result_label.text = mesaj
		result_label.show()
		result_label.add_theme_font_size_override("font_size", 150)
	
	if player_cannon: player_cannon.is_active = false
	if bot_cannon: bot_cannon.is_active = false
	
	# 3 saniye bekle ve Seçim Menüsüne dön
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://main_menu/selection_menu.tscn")

func bot_hamlesi():
	if oyun_bitti or not bot_cannon: return
	await get_tree().create_timer(1.5).timeout 
	
	var hedef = null
	if is_instance_valid(player_on_kule): hedef = player_on_kule
	elif is_instance_valid(player_kale): hedef = player_kale
	else: hedef = player_cannon
		
	if hedef and hedef.name != bot_hedef_ismi:
		bot_hedef_ismi = hedef.name
		bot_hata_carpan = 1.0

	if hedef:
		var mesafe_x = abs(bot_cannon.global_position.x - hedef.global_position.x)
		var g_hiz = sqrt((mesafe_x * 600.0) / 0.866)
		var bot_gucu = clamp((g_hiz / 10.0) + (randf_range(-8.0, 8.0) * bot_hata_carpan), 0.0, 100.0)
		bot_hata_carpan = max(0.1, bot_hata_carpan - 0.3)
		bot_cannon.bot_fire(deg_to_rad(-120), bot_gucu)

func _temalari_uygula():
	if not "Global" in self: return # Global autoload yoksa çalışma
	var p_tema = Global.temalar[Global.oyuncu_temasi]
	var b_tema = Global.temalar[Global.bot_temasi]
	
	_kaleyi_boya(player_kale, p_tema["kale"])
	_kaleyi_boya(bot_kale, b_tema["kale"])
	
	# Senin sahne yapına göre Sprite yolları
	if is_instance_valid(player_on_kule): 
		player_on_kule.get_node("TopPart/Sprite2D").texture = load(p_tema["kule"][0])
	if is_instance_valid(bot_on_kule): 
		bot_on_kule.get_node("TopPart/Sprite2D").texture = load(b_tema["kule"][0])

func _kaleyi_boya(kale, resimler):
	if not is_instance_valid(kale): return
	var ust = kale.get_node_or_null("TopPart/Sprite2D")
	if ust: ust.texture = load(resimler[0])
