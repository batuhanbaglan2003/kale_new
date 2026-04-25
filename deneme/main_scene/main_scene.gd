extends Node2D

@onready var player_cannon = $PlayerCannon
@onready var bot_cannon = $BotCannon
@onready var player_kale = $PlayerKale # Senin kalen
@onready var bot_kale = $BotKale     # Botun kalesi

var sira = "PLAYER" 

func _ready():
	player_cannon.is_active = true
	bot_cannon.is_active = false
	bot_cannon.side = "Right"

func _process(_delta):
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

func bot_hamlesi():
	await get_tree().create_timer(1.0).timeout 
	
	# 1. Hedef kim? (Kalen duruyorsa kale, yıkıldıysa senin topun)
	var hedef = player_kale if is_instance_valid(player_kale) else player_cannon
	
	# 2. X Eksenindeki mesafe (Range) ne kadar?
	var mesafe_x = abs(bot_cannon.global_position.x - hedef.global_position.x)
	
	# 3. MÜHENDİSLİK FİZİĞİ: 45 derecelik açıyla hedefi vurmak için gereken hız formülü
	# V = Karekök(Mesafe * Yerçekimi)
	var gerekli_hiz = sqrt(mesafe_x * 1800.0) # 1800, mermindeki gravity_force değeri
	
	# 4. Senin topunun formülü: Hız = Fare Uzaklığı * 2.5
	# Biz tersten gidiyoruz: Fare Uzaklığı = Hız / 2.5
	var fare_uzakligi = gerekli_hiz / 2.5
	
	# 5. HATA PAYI (Bot her defasında mükemmel vurmasın, biraz şaşsın)
	# Eğer bot çok ıska geçerse bu 40 sayılarını 20'ye düşür. Çok iyi vurursa 60'a çıkar.
	var rastgele_bozulma = randf_range(-40.0, 40.0)
	fare_uzakligi += rastgele_bozulma
	
	# 6. Bota sahte bir "Fare Tıklaması" noktası veriyoruz (Sol üst çapraz, -45 derece)
	# 45 derecenin sinüs ve kosinüs değeri yaklaşık 0.707'dir.
	var sahte_x = bot_cannon.global_position.x - (fare_uzakligi * 0.707)
	var sahte_y = bot_cannon.global_position.y - (fare_uzakligi * 0.707)
	
	var sahte_tiklama = Vector2(sahte_x, sahte_y)
	
	# Ateşle!
	bot_cannon.bot_fire(sahte_tiklama)
