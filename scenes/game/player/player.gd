extends CharacterBody2D

const SPEED : float = 125
const ZOOM  := 0.2

var knockback := Vector2.ZERO

@onready var camera := $camera

var vel := Vector2.ZERO

func _process(delta):
	var movement_input = Vector2(
		(float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left"))),
		(float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up")))
	)
	movement_input = movement_input.normalized()
	
	vel = lerp(vel, movement_input * SPEED, delta * 12)
	
	var is_running = vel.length() > 100
	if is_running:
		$AnimationPlayer.play("run")
	else:
		$AnimationPlayer.play("idle")
	
	$run_particles.emitting = is_running
	
	$sprites.scale.x = lerp($sprites.scale.x,
		float(get_global_mouse_position().x > global_position.x) * 2 - 1,
		delta * 12
	)
	if abs($sprites.scale.x) < 0.5: $sprites.scale.x *= -2
	
	$sprites.rotation = lerp($sprites.rotation, vel.x * 0.002, delta * 8)
	
	$camera.position = lerp($camera.position, get_local_mouse_position() * ZOOM, delta * 12)
	
	velocity = vel + knockback
	move_and_slide()
	
	knockback *= delta * 60 * 0.9
