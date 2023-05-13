extends CharacterBody2D

const SPEED : float = 125
const ZOOM  := 0.2
const DASH_SPEED := 700

var knockback := Vector2.ZERO

var dashing  := false
var can_dash := true
var dash_vel := Vector2.ZERO

@onready var camera := $camera

var vel := Vector2.ZERO

var weapon_on := 0
@export var weapons = []

func _ready():
	for i in len(weapons):
		weapons[i] = weapons[i].instantiate()
		weapons[i].position.y = -8
		
	add_child(weapons[0])

func _process(delta):
	if Input.is_action_just_pressed("swap"):
		swap_weapon()
	
	var movement_input = Vector2(
		(float(Input.is_action_pressed("right")) - float(Input.is_action_pressed("left"))),
		(float(Input.is_action_pressed("down")) - float(Input.is_action_pressed("up")))
	)
	movement_input = movement_input.normalized()
	
	vel = lerp(vel, movement_input * SPEED, delta * 12)
	
	if Input.is_action_just_pressed("dash") and can_dash and movement_input.length() != 0:
		dashing  = true
		can_dash = false
		
		dash_vel  = movement_input * DASH_SPEED
		$sprites/PlayerBody.material.set("shader_parameter/dir", Vector2(-movement_input.x * (int($sprites.scale.x > 0) * 2 - 1), -movement_input.y) * 0.35)
		create_tween().tween_property(
			$sprites/PlayerBody.material, "shader_parameter/dir", Vector2.ZERO, 0.25
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		$AnimationPlayer.play("dash")
		
		$dash_timer.start()
		
	$dash_particles.emitting = dashing
	
	var is_running = vel.length() > 100 and !dashing
	
	if is_running:
		$AnimationPlayer.play("run")
	elif !dashing:
		$AnimationPlayer.play("idle")
	
	$run_particles.emitting = is_running
	
	$sprites.scale.x = lerp($sprites.scale.x,
		float(get_global_mouse_position().x > global_position.x) * 2 - 1,
		delta * 12
	)
	if abs($sprites.scale.x) < 0.5: $sprites.scale.x *= -2
	
	$sprites.rotation = lerp($sprites.rotation, vel.x * 0.002, delta * 8)
	
	$camera.position = lerp($camera.position, get_local_mouse_position() * ZOOM, delta * 12)
	
	if !dashing:
		velocity = vel + knockback
	else:
		velocity = dash_vel
	
	move_and_slide()
	
	knockback -= knockback * delta * 5
	
	Global.player_position = global_position

func swap_weapon():
	remove_child(weapons[weapon_on])
		
	weapon_on += 1
	if weapon_on >= len(weapons):
		weapon_on = 0
			
	add_child(weapons[weapon_on])
	weapons[weapon_on].rotation = get_local_mouse_position().angle()
	weapons[weapon_on].scale.x = 0
	create_tween().tween_property(weapons[weapon_on], "scale:x", 1, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func _on_dash_timer_timeout():
	dashing = false
	$dash_recovery.start()

func _on_dash_recovery_timeout():
	can_dash = true
	flash()


func flash():
	$sprites/PlayerBody.material.set("shader_parameter/flash", true)
	$flash_timer.start()

func _on_flash_timer_timeout():
	$sprites/PlayerBody.material.set("shader_parameter/flash", false)
