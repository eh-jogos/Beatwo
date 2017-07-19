extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var game = self.get_node("../..")

onready var enemy_name = get_node("EnemyName")
onready var enemy_life = get_node("EnemyLife")

onready var player_name = get_node("Player")
onready var player_life = get_node("PlayerLife")

onready var animator = get_node("PanelAnimator")

func set_enemy_panel(name, health):
	enemy_name.set_text(name)
	enemy_life.set_text(String(health))
	pass

func set_player_panel(name, health):
	player_name.set_text(name)
	player_life.set_text(String(health))
	pass

func set_warning_animation(boolean):
	if boolean:
		animator.play("counter_warning")
	else:
		animator.play("normal")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	if !game.is_connected("enemy_panel", self, "set_enemy_panel"):
		game.connect("enemy_panel", self, "set_enemy_panel")
	
	if !game.is_connected("player_panel", self, "set_player_panel"):
		game.connect("player_panel", self, "set_player_panel")
	
	if !game.is_connected("counter_warning", self, "set_warning_animation"):
		game.connect("counter_warning", self, "set_warning_animation")
	
	animator.play("normal")
	pass
