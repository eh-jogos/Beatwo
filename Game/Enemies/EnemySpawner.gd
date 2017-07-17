extends Node2D

##########################
# Class Member Variables #
##########################
const ENEMY = preload("res://Enemies/Enemy01/Enemy01.tscn")
const MAX_ONSCREEN_ENEMIES = 3

onready var entities_layer = self.get_node("../EntitiesLayer")
onready var player = entities_layer.get_node("Player")


#############################
# Custom Method Definitions #
#############################
func spawn_enemies():
	var children = entities_layer.get_child_count()
	if children < 2:
		var to_spawn = MAX_ONSCREEN_ENEMIES
		for n in range(to_spawn):
			var enemy = ENEMY.instance()
			var posx = player.get_pos().x + floor(rand_range(-45,46))
			var posy = player.get_pos().y + floor(rand_range(-11,12))
			enemy.set_pos(Vector2(posx,posy))
			
			entities_layer.add_child(enemy)
			enemy.move_to(Vector2(posx,posy))
			
			pass
	pass

###########################
# Engine Standard Methods #
###########################

func _ready():
	randomize(true)
	
	set_process(true)
	pass

func _process(delta):
	spawn_enemies()
	pass