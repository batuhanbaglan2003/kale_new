extends Area2D

var speed = Vector2.ZERO
var gravity_force = 1800

func _ready():
	# 1. Arayüzden kopan sinyalleri KOD İLE zorla bağlıyoruz. Yüzde yüz çalışacak.
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _process(delta):
	if speed != Vector2.ZERO:
		speed.y += gravity_force * delta
		position += speed * delta
		rotation = speed.angle()

func hasar_ver(hedef):
	# Hedefin kendisinde take_damage var mı? (Örn: small_tower için)
	if hedef.has_method("take_damage"):
		hedef.take_damage(25)
	# Hedefin KENDİSİNDE yoksa, EBEVEYNİNDE (parent) var mı? (Örn: Kale sahneleri için)
	elif hedef.get_parent() != null and hedef.get_parent().has_method("take_damage"):
		hedef.get_parent().take_damage(25)
	
	# Hasar verdikten sonra mermiyi yok et
	queue_free()

# Eğer hedefin türü StaticBody2D veya CharacterBody2D ise bu çalışır
func _on_body_entered(body):
	print("Fiziksel gövdeye çarptım: ", body.name)
	hasar_ver(body)

# Eğer hedefin türü Area2D ise bu çalışır (Kale parçaların için)
func _on_area_entered(area):
	print("Area2D'ye çarptım: ", area.name)
	hasar_ver(area)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
