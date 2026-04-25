extends Area2D

var speed = Vector2.ZERO
var gravity_force = 1800

func _process(delta):
	if speed != Vector2.ZERO:
		speed.y += gravity_force * delta
		position += speed * delta
		rotation = speed.angle()

func _on_body_entered(body):
	# Çarptığın nesne bir 'take_damage' fonksiyonuna sahip mi?
	if body.has_method("take_damage"):
		body.take_damage(25) # 25 hasar gönderiyoruz
	
	queue_free() # Mermiyi yok et

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
