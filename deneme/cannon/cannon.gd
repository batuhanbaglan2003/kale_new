extends Node2D

@export var projectile_scene : PackedScene
@export_enum("Left", "Right") var side: String = "Left"

var launch_power = 2.0 

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	var target_angle = (mouse_pos - global_position).angle()
	
	# Açı sınırlandırma (Topun yerin altına bakmasını engeller)
	if side == "Left":
		rotation = clamp(target_angle, deg_to_rad(-90), deg_to_rad(0))
	else:
		rotation = clamp(target_angle, deg_to_rad(-180), deg_to_rad(-90))

func _input(event):
	# Sol tıklandığında ateş et
	if event is InputEventMouseButton and event.pressed:
		launch()

func launch():
	# Hata kontrolü
	if projectile_scene == null:
		print("HATA: Projectile Scene atanmamıs!")
		return
	
	var projectile = projectile_scene.instantiate()
	
	# Görüntündeki gibi küçük harf 'muzzle' kullanıldı
	projectile.global_position = $muzzle.global_position
	
	# Yön ve Güç hesabı
	var direction = Vector2.from_angle(rotation)
	var distance = global_position.distance_to(get_global_mouse_position())
	
	# Mermiye hızı gönder
	projectile.speed = direction * distance * launch_power
	
	# Mermiyi ana sahneye ekle
	get_tree().root.add_child(projectile)
