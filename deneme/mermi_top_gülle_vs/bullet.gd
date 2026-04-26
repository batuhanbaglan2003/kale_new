extends Area2D

var speed = Vector2.ZERO
var gravity_force = 500
var atici_taraf = "" 

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	await get_tree().create_timer(4.0).timeout
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
	
	if atici_taraf == "Left" and ("Player" in asil_hedef.name): return
	if atici_taraf == "Right" and ("Bot" in asil_hedef.name): return
	
	if asil_hedef.has_method("take_damage"):
		asil_hedef.take_damage(1)
		
	# KAMERA SARSINTISI: Sahnedeki Kamerayı bul ve sars!
	var kamera = get_tree().current_scene.get_node_or_null("Kamera")
	if kamera != null:
		kamera.sarsinti_baslat(25.0) # 25 şiddetinde titre
		
	queue_free()

func _on_body_entered(body): hasar_ver(body)
func _on_area_entered(area): hasar_ver(area)
