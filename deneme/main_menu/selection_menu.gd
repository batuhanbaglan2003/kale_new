extends Control

# --- SENİN BUTONLARIN ---
func _on_oyuncu_tema_1_pressed(): Global.oyuncu_temasi = 0
func _on_oyuncu_tema_2_pressed(): Global.oyuncu_temasi = 1
func _on_oyuncu_tema_3_pressed(): Global.oyuncu_temasi = 2

# --- BOTUN BUTONLARI ---
func _on_bot_tema_1_pressed(): Global.bot_temasi = 0
func _on_bot_tema_2_pressed(): Global.bot_temasi = 1
func _on_bot_tema_3_pressed(): Global.bot_temasi = 2

# --- SAVAŞI BAŞLAT BUTONU ---
func _on_savas_baslat_pressed():
	# Senin asıl oyun sahneni açar
	get_tree().change_scene_to_file("res://deneme/main_scene/main_scene.tscn")

func _on_button_pressed() -> void:
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	pass # Replace with function body.


func _on_button_4_pressed() -> void:
	pass # Replace with function body.


func _on_button_5_pressed() -> void:
	pass # Replace with function body.


func _on_button_6_pressed() -> void:
	pass # Replace with function body.


func _on_button_7_pressed() -> void:
	pass # Replace with function body.
