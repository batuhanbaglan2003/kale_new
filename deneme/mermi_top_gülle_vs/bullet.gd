extends Area2D

var speed = Vector2.ZERO
var gravity_force = 600
var atici_taraf = "" 

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	# Mermi 3 saniye içinde bir şeye çarpmazsa silinsin
	await get_tree().create_timer(3.0).timeout
	if is_instance_valid(self):
		queue_free()

func _process(delta):
	if speed != Vector2.ZERO:
		speed.y += gravity_force * delta
		position += speed * delta
		rotation = speed.angle()

func hasar_ver(hedef):
	var asil_hedef = hedef
	
	if not asil_hedef.has_method("take_damage") and asil_hedef.get_parent() != null:
		asil_hedef = asil_hedef.get_parent()
	
	# 1. HAYALET MODU: Kendi bölgendeysen içinden geç (Mermiyi yitirme!)
	# İsminin içinde "Player" olan her şey senin takımındır.
	if atici_taraf == "Left" and ("Player" in asil_hedef.name):
		return # return diyerek kodu burada kesiyoruz, mermi uçmaya devam ediyor.
		
	# İsminin içinde "Bot" olan her şey karşı takımdır.
	if atici_taraf == "Right" and ("Bot" in asil_hedef.name):
		return # return diyerek kodu burada kesiyoruz, mermi uçmaya devam ediyor.
	
	# 2. DÜŞMANA ÇARPTIYSAN HASAR VER
	if asil_hedef.has_method("take_damage"):
		asil_hedef.take_damage(25)
	
	# 3. Mermiyi sadece düşmana, yere veya duvara çarpınca yok et!
	queue_free()

func _on_body_entered(body):
	hasar_ver(body)

func _on_area_entered(area):
	hasar_ver(area)
