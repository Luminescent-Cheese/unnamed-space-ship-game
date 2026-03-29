extends Node2D

@export var playerHealth = 30.0

@onready var healthBar = $CanvasLayer/HealthBar
var enemy = preload("res://enemy ship/enemy.tscn")

#Used by Enemyies
var playerPosition

var activateScreenshake = true

func _ready():
	for i in 20:
		placeEnemy(0,0)

func _physics_process(delta: float):
	#Enemies use this for "pathfinding"
	playerPosition = $player.global_position
	#code that makes player healthbar smooth/ healthbar logic
	if playerHealth != healthBar.value:
		#activates screenshake
		if activateScreenshake:
			$player/playerCamera.shakeScreen = true
		activateScreenshake = false
		healthBar.self_modulate = Color(1.0, 0.0, 0.0)
		if playerHealth < healthBar.value:
			healthBar.value = healthBar.value - (healthBar.value - playerHealth)/3
		elif playerHealth > healthBar.value:
			healthBar.value = healthBar.value + (playerHealth - healthBar.value)/3
		if abs(playerHealth - healthBar.value) < 0.2:
			healthBar.value = playerHealth
	else:
		activateScreenshake = true
		healthBar.self_modulate = Color(1.0, 1.0, 1.0)
func placeEnemy(x,y):
	#spawns enemy at given cords
	var loadedEnemy = enemy.instantiate()
	loadedEnemy.global_position = Vector2(x,y)
	#signals
	loadedEnemy.enemyJustDied.connect(_on_shake_screen)
	add_child(loadedEnemy)

func _on_shake_screen() -> void:
	$player/playerCamera.shakeScreen = true
