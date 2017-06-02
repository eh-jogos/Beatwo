extends KinematicBody2D

##########################
# class member variables #
##########################

onready var animator = self.get_node("Animator")
onready var radar = self.get_node("EnemyDetection")


#############################
# Custom Method Definitions #
#############################

func animator():
	return animator

func radar():
	return radar

###########################
# Engine Standard Methods #
###########################

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
