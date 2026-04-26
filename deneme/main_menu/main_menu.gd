extends Node2D

func _on_play_pressed():
	# OYNA'ya basınca Seçim Ekranına git
	get_tree().change_scene_to_file("res://deneme/SelectionMenu.tscn")

func _on_exist_pressed():
	# ÇIKIŞ'a basınca oyunu kapat
	get_tree().quit()
	
