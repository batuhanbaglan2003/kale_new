extends Area2D

var speed = Vector2.ZERO
var gravity_force = 1800

func _process(delta):
<<<<<<< Updated upstream
	# Eğer hız atanmışsa hareket et
	if speed != Vector2.ZERO:
		# Yer çekimi ekle
		speed.y += gravity_force * delta
		# Konumu güncelle (Mesafe = Hız * Zaman)
		position += speed * delta
		# Gittiği yöne bakmasını sağla
		rotation = speed.angle()

# Çarpışma olduğunda çalışır
func _on_body_entered(body):
	# Arkadaşının kalelerinde bu fonksiyonun adı 'take_damage' olmalı
	if body.has_method("take_damage"):
		body.take_damage(25)
	
	# Bir şeye çarptığı an mermiyi sil
	queue_free()

# Ekrandan çıktığında belleği temizle
=======
	if speed != Vector2.ZERO:
		speed.y += gravity_force*delta
		position += delta*speed
		rotation = speed.angle()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(300)
	
	queue_free()

>>>>>>> Stashed changes
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
