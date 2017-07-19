extends KinematicBody2D

##########################
# class member variables #
##########################
onready var animator = self.get_node("Animator")
onready var target_animator = self.get_node("TargetAnimator")
onready var game = self.get_node("../..")

export var health = 3
export var hit_damage = 2

var is_flipped = false

signal attack_player
signal enemy_dead
signal internal_damage

#############################
# Custom Method Definitions #
#############################
func animator():
	return animator

func get_health():
	return health

func set_health(hp):
	health = hp

func get_hit_damage():
	return hit_damage

func get_flip():
	return is_flipped

func update_enemy_panel():
	game.emit_signal("enemy_panel",self.get_name(),health)

func take_damage(dmg):
	self.emit_signal("internal_damage",dmg)

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

func _ready():
	
	if self.get_pos().x < 360/2:
		is_flipped = true
	
	pass
