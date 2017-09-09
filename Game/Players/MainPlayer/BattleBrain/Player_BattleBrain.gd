extends Node

##########################
# class member variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var player = get_node("..") # Player Node


# Variables that this Brain must maintain in order to make decisions come here grouped by similarity/use

## Variables for keeping track of enemies inside the player's attack area
var attack_target = null # Variable to hold the target the player character is currently focusing in
var counter_target = [] # Array to hold potential counter targets for the brief time they will be available

## Variables for keeping track of the characters "state of mind" or similar things
var vulnerable = true # Toggle if player takes damage or not
var focused = false # toggles wheter the player is able to change "attack_targets" or not

#############################
# Custom Method Definitions #
#############################

# Returns "attack_target" to whoever is asking for it
func get_attack_target():
	return attack_target

# Funtion used to update "attack_target"
## It takes a parameter which should be the enemy node which should be targeted, or null
func set_attack_target(new_target):
	
	# If current target is diferent than new_target, and neither of them is null, disables "target animation" on enemy node
	if attack_target != new_target and attack_target != null and new_target != null:
		attack_target.set_target(false)
	
	# If new_target is not null, and player is not "focused" on an enemy already...
	if new_target != null and focused == false:
		new_target.set_target(true) # ...activates "target animation" on the "new_target"...
		player.update_enemy_panel(new_target.get_name(), new_target.get_health()) # ...and update the main panel(s) with the current targeted enemy info.
	
	# If target IS null OR IS FALSE, update current target to new_target
	## Whenever the player is not focused, it should be able to change targets, so that's half the condition
	## The null part is for when the current target dies and becomes null, but you keep attacking the air (focused)
	## it allows for the target to be changed wihtout causing errors and adding an exception to be able to change to "null" target without needing to "unfocus"
	if new_target == null or focused == false:
		attack_target = new_target

# Returns "counter_target" to whoever is asking for it
func get_counter_target():
	return counter_target

# Adds current attacking enemy ("target") to counter target list and sounds off "counter_warning" alarm
func set_counter_target(target):
	counter_target += target
	player.counter_warning(true)
#	print(counter_target)

# Resets "counter_target" and kills off the "counter_warning" alarm
func clean_counter_target():
	counter_target = []
	player.counter_warning(false)

# Returns vulnerability boolean to whoever is asking
func get_vulnerability():
	return vulnerable

# Function used to set the vulnerability boolean and choose the "vulnerable animation" accordingly
## TRUE means Vulnerable
## FALSE means Invulnerable
## There is an animation player dedicated only to vulnerable and invulnerable animations
## so that the player can have a visual feddback about his own vulnerability or invulnerability no matter which action it's on
func set_vulnerability(boolean):
	var vulnerable_animator = player.get_node("VulnerableAnimator")
	
	vulnerable = boolean
	
	if vulnerable:
		vulnerable_animator.play("vulnerable")
	else:
		vulnerable_animator.play("invulnerable")

# Return "focused" boolean to whoever is asking
func get_focus():
	return focused

# Sets "focused" boolean
## TRUE means Focused
## FALSE means Unfocused
func set_focus(boolean):
    focused = boolean

###########################
# Engine Standard Methods #
###########################

# Called every time the node is added to the scene.
func _ready():
	pass
