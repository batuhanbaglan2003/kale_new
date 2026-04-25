extends Node2D

@export var projectile_scene : PackedScene
@export_enum("Left", "Right") var side: String = "Left"

var is_active = false 
var is_charging = false
var current_power = 0.0
var max_power = 100.0   # Bar artık %100 üzerinden hesaplanıyor
var charge_speed = 75.0 # Saniyede %75 dolar (Yaklaşık 1.3 saniyede fullenir)

@onready var power_bar = $ProgressBar 

func _ready():
	if power_bar != null:
		power_bar.hide()
		power_bar.max_value = 100

func _process(delta):
	if not is_active or side == "Right": return

	var mouse_pos = get_global_mouse_position()
	var target_angle = (mouse_pos - global_position).angle()
	rotation = clamp(target_angle, deg_to_rad(-90), deg_to_rad(0))

	if is_charging:
		current_power += charge_speed * delta
		if current_power > max_power:
			current_power = max_power
		if power_bar != null:
			power_bar.value = current_power

func _input(event):
	if not is_active or side == "Right": return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_charging = true
				current_power = 0.0 
				if power_bar != null: power_bar.show()
			elif not event.pressed and is_charging:
				is_charging = false
				if power_bar != null: power_bar.hide()
				launch(current_power)

# Bot artık fareyle uğraşmıyor, doğrudan açı ve güç gönderiyor
func bot_fire(hedef_aci, bot_gucu):
	rotation = hedef_aci
	launch(bot_gucu)

func launch(power_value):
	if projectile_scene == null: return
	var projectile = projectile_scene.instantiate()
	projectile.global_position = $muzzle.global_position
	
	var direction = Vector2.from_angle(rotation)
	
	# YENİ FİZİK: Çıkış hızı ciddi oranda düşürüldü. Güç 100 ise hız 1000 olacak.
	projectile.speed = direction * 10.0 * power_value 
	
	projectile.atici_taraf = self.side 
	projectile.add_to_group("mermiler") 
	get_tree().root.add_child(projectile)
	
	is_active = false
