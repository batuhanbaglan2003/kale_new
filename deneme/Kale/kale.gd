extends Node2D

# 1. Defining the health of the parts
var top_health = 1
var mid_health = 1
var bottom_health = 1

# 2. Referencing the nodes based on your hierarchy
# Make sure these names match the nodes in your Scene Tree exactly!
@onready var top_part = $TopPart
@onready var mid_part = $MidPart
@onready var bottom_part = $BottomPart

# 3. Function to handle damage
func take_damage():
	if top_health > 0:
		top_health -= 1
		top_part.queue_free() # Completely removes the top part
		print("Top part destroyed!")
		
	elif mid_health > 0:
		mid_health -= 1
		mid_part.queue_free() # Completely removes the middle part
		print("Middle part destroyed!")
		
	elif bottom_health > 0:
		bottom_health -= 1
		bottom_part.queue_free() # Completely removes the bottom part
		print("Castle destroyed! Game Over.")

# FOR TESTING: Triggered when you press the Space bar
func _input(event):
	if event.is_action_pressed("ui_accept"):
		take_damage()
