extends Node2D


##########################
# Class Member Variables #
##########################

# Class Signals 
## In this case, I'm centralizing these signals on the main "game" node for this mode, so that 
## different parts of the code, in different levels of identatiion, can connect and disconnect easily with them.
### The flow is usually that either the player or the enemy script access this root node and emits these signals, which are captured by the panel script
### This way the player and enemy don't have find a way to directly connect with the panel node.
### Also doing it like this, is easier to connect the signals inside the panel script to this root node than to the player or enemy nodes, 
### specially since the enemy nodes are added dinamycally do the treeview.
signal enemy_panel(name, health) # signal to change panel values on the enemy side
signal player_panel(name, health) # signal to change panel values on the player side
signal counter_warning(boolean) # signal to display counter warning animation on the whole panel


#############################
# Custom Method Definitions #
#############################



###########################
# Engine Standard Methods #
###########################

# Called every time the node is added to the scene.	
func _ready():
	pass
