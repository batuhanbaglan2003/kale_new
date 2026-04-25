extends Camera2D

# 🛠️ AYARLAR: Geçişleri yavaşlattık, zoom değerlerini "geniş" yaptık.
var follow_speed = 2.0    # Süzülme hızı
var zoom_speed = 1.0      # Yakınlaşma hızı
var target_zoom = Vector2(0.75, 0.75) # Ana geniş plan (Eskiden 0.85-0.9'du)
var target_node = null
var shake_amount = 0.0

func _process(delta):
	# 1. Sarsıntı (Vuruş anında)
	if shake_amount > 0:
		offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_amount
		shake_amount = lerp(shake_amount, 0.0, 5.0 * delta)
	else:
		offset = Vector2.ZERO

	# 2. Yumuşak Zoom Geçişi
	zoom = zoom.lerp(target_zoom, zoom_speed * delta)

	# 3. Takip ve Odak Mantığı
	var mermiler = get_tree().get_nodes_in_group("mermiler")
	
	if mermiler.size() > 0:
		var mermi = mermiler[0]
		if is_instance_valid(mermi):
			if mermi.atici_taraf == "Right": 
				# Bot atarken: Bayağı genişten (0.7) izle ki tüm sahne görünsün
				target_zoom = Vector2(0.7, 0.7) 
				var middle_x = (get_parent().get_node("PlayerCannon").global_position.x + get_parent().get_node("BotCannon").global_position.x) / 2
				global_position = global_position.lerp(Vector2(middle_x, mermi.global_position.y), follow_speed * delta)
			else: 
				# Oyuncu atarken: Eskisi kadar burnunun dibine girme (2.0 yapıldı)
				global_position = global_position.lerp(mermi.global_position, follow_speed * delta)
				target_zoom = Vector2(2.0, 2.0) 
	else:
		if target_node != null and is_instance_valid(target_node):
			if "Bot" in target_node.name:
				# Bot turu beklerken ferah görüş (0.75)
				target_zoom = Vector2(0.75, 0.75)
				var middle_x = (get_parent().get_node("PlayerCannon").global_position.x + get_parent().get_node("BotCannon").global_position.x) / 2
				global_position = global_position.lerp(Vector2(middle_x, global_position.y), follow_speed * delta)
			else:
				# Oyuncu turunda topa bakarken daha geniş bak (1.1 yapıldı, eskiden 1.5'ti)
				global_position = global_position.lerp(target_node.global_position, follow_speed * delta)
				target_zoom = Vector2(1.1, 1.1) 
		else:
			# Giriş sinematiği (3 saniyelik kısım) için en geniş plan
			target_zoom = Vector2(0.7, 0.7)

func odaklan(node):
	target_node = node

func sarsinti_baslat(siddet):
	shake_amount = siddet
