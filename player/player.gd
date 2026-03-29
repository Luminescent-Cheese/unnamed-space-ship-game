extends CharacterBody2D

var mouseDirection = Vector2.ZERO
var speed = 100
var canFire = true
var currentType = "normal"
var chargeSpeed
#used for sprite animation
var neededChangeInDirection = 0

@onready var bullet = preload("res://bullet/bullet.tscn")

func _ready():
	$"engine particles".emitting = true

func _physics_process(delta: float) -> void:
	#direction to mouse (used for things in multiple types)
	mouseDirection = global_position.direction_to(get_global_mouse_position())
	if currentType == "normal":
		var currentDirection = velocity.normalized()
		#movement code
		neededChangeInDirection = rad_to_deg(mouseDirection.angle()) - rad_to_deg(currentDirection.angle())
		#distance to mouse
		speed = (get_global_mouse_position() - global_position).length() * 1.5
		currentDirection = currentDirection.lerp(mouseDirection, delta * 10)
		if speed > 1200:
			speed = 1200
		velocity = currentDirection * speed
		if Input.is_action_pressed("fire") and canFire:
			canFire = false
			$bulletTimer.start()
			var newBullet = bullet.instantiate()
			newBullet.aimDirection = mouseDirection
			newBullet.global_position = global_position
			newBullet.bulletType = "player"
			add_sibling(newBullet)
		if Input.is_action_just_pressed("charge"):
			$ChargeParticles.emitting = false
			velocity = currentDirection * speed
			chargeSpeed = 3000
			currentType = "charge"
			#extra charge particles
			$ChargeParticles.emitting = true
			$ExtraChargeParticles.emitting = true
			$ExtraChargeParticles2.emitting = true
		#looks at current direction 
		look_at(global_position + currentDirection)
	if currentType == "charge":
		var currentDirection = velocity.normalized()
		if chargeSpeed >= 1200:
			if chargeSpeed < 3000:
				currentDirection = currentDirection.lerp(mouseDirection, delta * (6000/chargeSpeed))
			velocity = chargeSpeed * currentDirection
			if chargeSpeed < 4000:
				chargeSpeed -= 50
			else:
				chargeSpeed += 100
			look_at(global_position + currentDirection)
		else:
			currentType = "normal"
	move_and_slide()
		
func _on_bullet_timer_timeout() -> void:
	canFire = true
