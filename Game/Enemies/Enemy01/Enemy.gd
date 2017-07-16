extends KinematicBody2D

##########################
# class member variables #
##########################
onready var animator = self.get_node("Animator")
onready var target_animator = self.get_node("TargetAnimator")
onready var game = self.get_node("../..")

export var health = 3
export var hit_damage = 2

signal attack_player(damage)

#############################
# Custom Method Definitions #
#############################
func get_health():
	return health

func take_damage(dmg):
#	animator.play("dying")
	health -= dmg
	
	game.emit_signal("enemy_panel",self.get_name(),health)
	
	if health <= 0:
		self.queue_free()
#	var current_pos = self.get_pos()
#	self.set_pos(Vector2(current_pos.x+110,current_pos.y))
	pass

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
	# Called every time the node is added to the scene.
	# Initialization here
	animator.play("idle")
	pass
