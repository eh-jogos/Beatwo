extends Node2D

##########################
# Class Member Variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var entities_layer = self.get_node("../EntitiesLayer") # The YSort node that holds all entities of the game mode.

# Class Constants
const ENEMY = preload("res://Enemies/Enemy01/Enemy01.tscn") # Enemy scene for instancing
const MAX_ONSCREEN_ENEMIES = 4


#############################
# Custom Method Definitions #
#############################

# Method for spawning enemies
## Right now It creates a for Loop that always spawn the Maximum ammount of onscreen enemies
## @FUTURE_DATE - make it so that it doesn't spawn a fixed ammount of enemies?
## @FUTURE_DATE - make it so that it never spawns two enemies in the same "Position2d"
## In each iteration of the loop: ...
func spawn_enemies():
	for n in range(MAX_ONSCREEN_ENEMIES):
		var enemy = ENEMY.instance() # ...it instances a new ENEMY...
		var pos = self.get_child(floor(rand_range(0,self.get_child_count()))).get_pos() # ... it gets the position of a random child "Position2d" node from the EnemySpawner...
		pos.y -= 30 # ...offsets that position 30 pixels up because of the origin of the ENEMY node
		enemy.set_pos(pos) # ...sets the pos variable to the newly instantiated enemy...
		
		entities_layer.add_child(enemy) #... and finaly, adds that enemy as a child of the entities_layer

		
###########################
# Engine Standard Methods #
###########################

# Called every time the node is added to the scene.
func _ready():
	randomize(true)
	set_process(true)

# Called every time a frame is drawn, not necessarily at regular intervals
## delta is ammount of time elapsed since last time it executed.
func _process(delta):
	var children = entities_layer.get_child_count()
	if children < 2:
		spawn_enemies()