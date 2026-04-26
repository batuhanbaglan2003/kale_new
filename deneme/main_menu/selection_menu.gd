extends Control

# --- OYUNCU TEMALARI ---
func _on_button_pressed():
	Global.oyuncu_temasi = 0

func _on_button_2_pressed():
	Global.oyuncu_temasi = 1

func _on_button_3_pressed():
	Global.oyuncu_temasi = 2


# --- BOT TEMALARI ---
func _on_button_4_pressed():
	Global.bot_temasi = 0

func _on_button_5_pressed():
	Global.bot_temasi = 1

func _on_button_6_pressed():
	Global.bot_temasi = 2


# --- SAVAŞI BAŞLAT BUTONU (Button 7) ---
func _on_button_7_pressed():
	# Dosya yolunu ekran görüntündeki FileSystem'e göre düzelttim:
	get_tree().change_scene_to_file("res://main_scene/main_scene.tscn")
