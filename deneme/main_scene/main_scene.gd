extends Node2D

@onready var player_cannon = $PlayerCannon
@onready var bot_cannon = $BotCannon
@onready var player_kale = $PlayerKale
@onready var bot_kale = $BotKale
@onready var player_on_kule = $PlayerOnKule
@onready var bot_on_kule = $BotOnKule
@onready var result_label = $UI/ResultLabel

var sira = "PLAYER" 
var oyun_bitti = false

# YAPAY ZEKA HAFIZASI
var bot_hedef_ismi = ""
var bot_hata_carpan = 1.0 # 1.0 = %100 Hata, 0.0 = Kusursuz İsabet

func _ready():
	player_cannon.is_active = true
	bot_cannon.is_active = false
	bot_cannon.side = "Right"
	if result_label != null: result_label.hide()

func _process(_delta):
	if oyun_bitti: return

	if not is_instance_valid(bot_kale): oyunu_sonlandir("KAZANDINIZ!") ; return
	if not is_instance_valid(player_kale): oyunu_sonlandir("KAYBETTİNİZ...") ; return

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
				bot_hamlesi()
		"BOT":
			if mermi_sayisi > 0:
				sira = "WAIT_PLAYER"
		"WAIT_PLAYER":
			if mermi_sayisi == 0:
				sira = "PLAYER"
				player_cannon.is_active = true

func oyunu_sonlandir(mesaj):
	oyun_bitti = true
	if result_label != null:
		result_label.text = mesaj
		result_label.show()
	player_cannon.is_active = false
	bot_cannon.is_active = false
	print("Oyun Bitti: ", mesaj)

func bot_hamlesi():
	if oyun_bitti: return
	await get_tree().create_timer(1.0).timeout 
	
	# HEDEF SEÇİMİ
	var hedef = null
	if is_instance_valid(player_on_kule): hedef = player_on_kule
	elif is_instance_valid(player_kale): hedef = player_kale
	else: hedef = player_cannon
		
	# YAPAY ZEKA: Hedef değiştiyse botun kafası karışsın ve baştan öğrenmeye başlasın
	if hedef.name != bot_hedef_ismi:
		bot_hedef_ismi = hedef.name
		bot_hata_carpan = 1.0 # Hatayı tekrar maksimuma çıkar
		print("Bot yeni bir hedefe odaklandı: ", hedef.name)

	var mesafe_x = abs(bot_cannon.global_position.x - hedef.global_position.x)
	var gerekli_hiz = sqrt((mesafe_x * 600.0) / 0.866)
	var mukemmel_guc = gerekli_hiz / 10.0
	
	# YAPAY ZEKA: Öğrenen Hata Payı
	var max_sapma = 8.0 # Bot en fazla 8 güç birimi sapabilir
	var rastgele_sapma = randf_range(-max_sapma, max_sapma) * bot_hata_carpan
	
	var bot_gucu = mukemmel_guc + rastgele_sapma
	bot_gucu = clamp(bot_gucu, 0.0, 100.0)
	
	# YAPAY ZEKA: Bot her atışta o hedefe daha çok alışır (Hata payı her atışta %30 azalır)
	# Yani 1. atışta çok sapar, 2. atışta az sapar, 3. atışta tam isabet ettirir!
	bot_hata_carpan = max(0.1, bot_hata_carpan - 0.3)
	
	var kavis_acisi = deg_to_rad(-120) 
	bot_cannon.bot_fire(kavis_acisi, bot_gucu)
