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
	if attack_target != target and attack_target != null and target != null:
		attack_target.set_target(false)
	
	if target != null and focused == false:
		target.set_target(true)
		player.update_enemy_panel(target.get_name(), target.get_health())
	
	if target == null or focused == false:
		attack_target = target

func get_counter_target():
	return counter_target

func set_counter_target(target):
	counter_target += target
	player.counter_warning(true)
#	print(counter_target)

func clean_counter_target():
	counter_target = []
	player.counter_warning(false)

func get_vulnerability():
	return vulnerable

func set_vulnerability(boolean):
	var vulnerable_animator = player.get_node("VulnerableAnimator")
	
	vulnerable = boolean
	
	if vulnerable:
		vulnerable_animator.play("vulnerable")
	else:
		vulnerable_animator.play("invulnerable")

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
