extends Node2D

@export var projectile_scene : PackedScene
@export_enum("Left", "Right") var side: String = "Left"

var launch_power = 2.5 
var is_active = false # KİLİT SİSTEMİ (Sıra kontrolü)

func _process(_delta):
	# Sıra bizde değilse VEYA bu bot topuysa fareyi takip etme!
	if not is_active or side == "Right": 
		return

	var mouse_pos = get_global_mouse_position()
	var target_angle = (mouse_pos - global_position).angle()
	rotation = clamp(target_angle, deg_to_rad(-90), deg_to_rad(0))

func _input(event):
	# Kilitliyse farenin tıklamasını yoksay
	if not is_active or side == "Right":
		return

	if event is InputEventMouseButton and event.pressed:
		launch(get_global_mouse_position())

# Sağdaki botun kendi kendine hedef alıp ateşlemesi için özel fonksiyon
func bot_fire(hedef_pozisyon):
	var target_angle = (hedef_pozisyon - global_position).angle()
	rotation = clamp(target_angle, deg_to_rad(-180), deg_to_rad(-90))
	launch(hedef_pozisyon)

func launch(target_pos):
	if projectile_scene == null: return
	var projectile = projectile_scene.instantiate()
	projectile.global_position = $muzzle.global_position
	
	var direction = Vector2.from_angle(rotation)
	var distance = global_position.distance_to(target_pos)
	projectile.speed = direction * distance * launch_power
	
	# HAKEMİN MERMİYİ TAKİP EDEBİLMESİ İÇİN MERMİYE ETİKET TAKIYORUZ
	projectile.add_to_group("mermiler") 
	
	get_tree().root.add_child(projectile)
	
	# Ateş edildikten sonra kendini kilitle
	is_active = false
