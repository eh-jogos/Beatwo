extends Node

##########################
# class member variables #
##########################
onready var player = get_node("..")

var attack_target = null
var counter_target = []

var vulnerable = true
var focused = false

#############################
# Custom Method Definitions #
#############################

func get_attack_target():
	return attack_target

func set_attack_target(target):
#	if attack_target != null and attack_target.has_method("set_target"):
#		attack_target.set_target(false)
	if target != null and focused != true:
		target.set_target(true)
	
	if focused != true:
		attack_target = target
		player.update_enemy_panel(target.get_name(), target.get_health())

func get_counter_target():
	return counter_target

func set_counter_target(target):
	counter_target = [] + target

func get_vulnerability():
	return vulnerable

func set_vulnerability(boolean):
	vulnerable = boolean

func get_focus():
	return focused

func set_focus(boolean):
    focused = boolean

###########################
# Engine Standard Methods #
###########################

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
