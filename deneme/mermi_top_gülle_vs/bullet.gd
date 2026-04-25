extends Area2D

var speed = Vector2.ZERO
var gravity_force = 1800

func _ready():
	# Sinyalleri zorla bağlıyoruz
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	# 🛡️ GÜVENLİK SİGORTASI: Mermi 3 saniye içinde hiçbir şeye çarpmazsa uzaya uçmuştur. Kendini imha etsin.
	await get_tree().create_timer(3.0).timeout
	if is_instance_valid(self):
		queue_free()

func _process(delta):
	if speed != Vector2.ZERO:
		speed.y += gravity_force * delta
		position += speed * delta
		rotation = speed.angle()

func hasar_ver(hedef):
	if hedef.has_method("take_damage"):
		hedef.take_damage(25)
	elif hedef.get_parent() != null and hedef.get_parent().has_method("take_damage"):
		hedef.get_parent().take_damage(25)
	
	queue_free()

# Çarpışma tetikleyicileri
func _on_body_entered(body):
	hasar_ver(body)

func _on_area_entered(area):
	hasar_ver(area)
