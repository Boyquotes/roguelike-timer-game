extends CharacterBody2D

const SPEED : float = 125

func _process(delta):
	var movement_input = Vector2(
		(float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left"))),
		(float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up")))
	)
	movement_input = movement_input.normalized()
	
	velocity = lerp(velocity, movement_input * SPEED, delta * 12)
	
	var is_running = velocity.length() > 100
	if is_running:
		$AnimationPlayer.play("run")
	else:
		$AnimationPlayer.play("idle")
	
	$run_particles.emitting  = is_running
	
	$sprites.scale.x = lerp($sprites.scale.x,
		float(get_global_mouse_position().x > global_position.x) * 2 - 1,
		delta * 12
	)
	
	move_and_slide()
