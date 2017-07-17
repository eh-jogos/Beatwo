extends KinematicBody2D

##########################
# class member variables #
##########################

onready var animator = self.get_node("Animator")
onready var radar = self.get_node("EnemyDetection")
onready var game = self.get_node("../..")
onready var player_name = self.get_name()

export var health = 10
export var hit_damage = 5


signal internal_damage

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
	update_player_panel(player_name, health)

func get_hit_damage():
	return hit_damage

func set_hit_damage(dmg):
	hit_damage = dmg

func take_damage(dmg):
	self.emit_signal("internal_damage",dmg)

func update_enemy_panel(enemy_name, enemy_health):
	game.emit_signal("enemy_panel", enemy_name, enemy_health)

func update_player_panel(name, health):
	game.emit_signal("player_panel", name, health)

###########################
# Engine Standard Methods #
###########################

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)

func _process(delta):
	update_player_panel(player_name, health)
	pass
