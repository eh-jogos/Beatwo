extends Node2D

##########################
# Class Member Variables #
##########################
const ENEMY = preload("res://Enemies/Enemy01/Enemy01.tscn")
const MAX_ONSCREEN_ENEMIES = 4

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
			var pos = self.get_child(floor(rand_range(0,self.get_child_count()))).get_pos()
			pos.y -= 30
			enemy.set_pos(pos)
			
			entities_layer.add_child(enemy)
			
			pass
	pass

###########################
# Engine Standard Methods #
###########################

func _ready():
	randomize(true)
	set_process(true)


func _process(delta):
	spawn_enemies()