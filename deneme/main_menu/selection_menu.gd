extends Control

# --- OYUNCU TEMALARI (Üstteki 3 Buton) ---
func _on_button_pressed(): 
	Global.oyuncu_temasi = 0
	print("Oyuncu için Tema 1 seçildi")

func _on_button_2_pressed(): 
	Global.oyuncu_temasi = 1
	print("Oyuncu için Tema 2 seçildi")

func _on_button_3_pressed(): 
	Global.oyuncu_temasi = 2
	print("Oyuncu için Tema 3 seçildi")

# --- BOT TEMALARI (Ortadaki 3 Buton) ---
func _on_button_4_pressed(): 
	Global.bot_temasi = 0
	print("Bot için Tema 1 seçildi")

func _on_button_5_pressed(): 
	Global.bot_temasi = 1
	print("Bot için Tema 2 seçildi")

func _on_button_6_pressed(): 
	Global.bot_temasi = 2
	print("Bot için Tema 3 seçildi")

# --- SAVAŞI BAŞLAT BUTONU (En alttaki Button 7) ---
func _on_button_7_pressed():
	print("Oyun Başlıyor...")
	# Sahne yolunun senin dosyalarına uyduğundan emin ol
	get_tree().change_scene_to_file("res://main_scene/main_scene.tscn")
