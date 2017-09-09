extends KinematicBody2D

##########################
# class member variables #
##########################

# All instantiation of node elements, or of stuff that depends on 'onready' comes here at the top!
onready var animator = self.get_node("Animator") # Main Enemy Animator
onready var target_animator = self.get_node("TargetAnimator") # Target Animator - toggles an animation whenever the enemy is being targeted by the player
onready var game = self.get_node("../..") # Main Game node

# Player's Internal Variables and Stats
export var health = 3 # Enemy's Life
export var hit_damage = 2 # Damage of enemy attacks

var is_flipped = false # Controls whether the enemy is facing right (false) or left (true)

# Player's internal signals
signal attack_player # signal sent when the enemy is going to attack the player. This is receive both internally by the enemy entity as well as by the player entity
signal enemy_dead # Signal sent when the enemy dies
signal internal_damage # Signal to deal with damage received

#############################
# Custom Method Definitions #
#############################

# Method to easily access the animator node
func animator():
	return animator

# Method to return the enemy health
func get_health():
	return health

# Method to set the enemy health
func set_health(hp):
	health = hp

# Method to return the enemy hit_damage
func get_hit_damage():
	return hit_damage

# Method to return the enemy "flip" boolean
func get_flip():
	return is_flipped

# Method to update enemy side of the panel
func update_enemy_panel():
	game.emit_signal("enemy_panel",self.get_name(),health)

# Method called by player attack, to trigger damage dealing actions inside the enemy
func take_damage(dmg):
	self.emit_signal("internal_damage",dmg)

# Method called by the player "SenseMachine" to toggle highlitght on current targeted enemy
# or deactivate it on enemies that are not targeted anymore.
func set_target(boolean):
	if boolean:
		if !target_animator.get_current_animation() == "active":
			target_animator.play("active")
	else:
		if !target_animator.get_current_animation() == "inactive":
			target_animator.play("inactive")

###########################
# Engine Standard Methods #
###########################
# Called every time the node is added to the scene.
func _ready():
	
	# Detects if enemy entity is in the right half of the stage, and if so, 
	# flips the enemy entity so that if faces the player, if not, unflips it
	if self.get_pos().x < 360/2:
		is_flipped = true
	else: 
		is_flipped = false
	
	pass
