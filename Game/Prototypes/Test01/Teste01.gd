extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal enemy_panel(name, health)
signal player_panel(name, health)
signal counter_warning(boolean)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
