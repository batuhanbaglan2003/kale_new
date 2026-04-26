extends Node2D

func _on_play_pressed():
	# Oyuncuyu seçim ekranına gönderir
	get_tree().change_scene_to_file("res://main_menu/SelectionMenu.tscn")

func _on_exist_pressed():
	# ÇIKIŞ'a basınca oyunu kapat
	get_tree().quit()
	
