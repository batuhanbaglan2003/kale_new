extends Node2D

@export var projectile_scene : PackedScene
@export_enum("Left", "Right") var side: String = "Left"

var launch_power = 2.5 

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	var target_angle = (mouse_pos - global_position).angle()
	
	# Açı sınırlama: Top yerin altına ateş etmesin
	if side == "Left":
		rotation = clamp(target_angle, deg_to_rad(-90), deg_to_rad(0))
	else:
		rotation = clamp(target_angle, deg_to_rad(-180), deg_to_rad(-90))

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		launch()

func launch():
	if projectile_scene == null: return
	
	var projectile = projectile_scene.instantiate()
	# DİKKAT: Sahne ağacında ismin 'muzzle' (küçük harf) olduğundan emin ol
	projectile.global_position = $muzzle.global_position
	
	var direction = Vector2.from_angle(rotation)
	var distance = global_position.distance_to(get_global_mouse_position())
	
	projectile.speed = direction * distance * launch_power
	get_tree().root.add_child(projectile)
