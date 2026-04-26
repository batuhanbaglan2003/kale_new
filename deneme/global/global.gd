extends Node

# Varsayılan seçimler
var oyuncu_temasi = 0
var bot_temasi = 1

# Klasörlerindeki GERÇEK dosya yolları
var temalar = [
	{
		"ad": "Tema 1",
		"top": "res://deneme/görseller/tema1/kkale1top.png",
		"kale": [
			"res://deneme/görseller/tema1/kale1.png", 
			"res://deneme/görseller/tema1/yıkıkkalee1.1.png", 
			"res://deneme/görseller/tema1/yıkıkkalee1.png"
		],
		"kule": [
			"res://deneme/görseller/tema1/kule1.png", 
			"res://deneme/görseller/tema1/yıkıkkule1.png"
		]
	},
	{
		"ad": "Tema 2",
		"top": "res://deneme/görseller/tema2/topiki.png",
		"kale": [
			"res://deneme/görseller/tema2/ikinci kale.png", 
			"res://deneme/görseller/tema2/yıkıkkale2.1.png", 
			"res://deneme/görseller/tema2/yıkıkkale2.png"
		],
		"kule": [
			# Tema 2 için özel bir kule resmi göremedim, o yüzden 
			# şimdilik kalenin resimlerini kuleye de atadım. 
			# Özel kule resmi eklersen burayı değiştirirsin.
			"res://deneme/görseller/tema2/ikinci kale.png", 
			"res://deneme/görseller/tema2/yıkıkkale2.png"
		]
	},
	{
		"ad": "Tema 3",
		"top": "res://deneme/görseller/tema3/top3.png",
		"kale": [
			"res://deneme/görseller/tema3/kale1.png", 
			"res://deneme/görseller/tema3/kale2.png", 
			"res://deneme/görseller/tema3/kale3.png"
		],
		"kule": [
			"res://deneme/görseller/tema3/kule.png", 
			"res://deneme/görseller/tema3/kule3.png"
		]
	}
]
