extends KinematicBody2D

##########################
# class member variables #
##########################

onready var animator = self.get_node("Animator")
onready var radar = self.get_node("EnemyDetection")

export var health = 10
export var hit_damage = 2

signal internal_damage(dmg)

#############################
# Custom Method Definitions #
#############################

func animator():
	return animator

func radar():
	return radar

func get_health():
	return health

func set_health(hp):
	health = hp

func get_hit_damage():
	return hit_damage

func set_hit_damage(dmg):
	hit_damage = dmg

func take_damage(dmg):
	self.emit_signal("internal_damage",dmg)

###########################
# Engine Standard Methods #
###########################

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	pass
