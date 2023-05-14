extends CharacterBody2D

var hp := 3
var knockback := Vector2.ZERO
var attacking = false

func _process(delta):
	if !attacking: 
		$sprites/sprite/tail/target.position = lerp(
			$sprites/sprite/tail/target.position,
			Vector2(-4, -11) + Vector2(4, 0).rotated(Global.time),
			delta * 2
		)
	
	$sprites.scale.x = lerp($sprites.scale.x,
		float(Global.player_position.x > global_position.x) * 2 - 1,
		delta * 12
	)
	if abs($sprites.scale.x) < 0.5: $sprites.scale.x *= -2
	
	$sprites.rotation = knockback.x * 0.0025
	scale.x = 1.0 - knockback.length() * 0.001
	scale.y = 1.0 - knockback.length() * 0.001
	
	velocity = knockback
	knockback -= knockback * delta * 4
	
	move_and_slide()

func hit(attack):
	hp -= attack.damage
	knockback += attack.knockback
	
	flash()
	
	if hp <= 0:
		queue_free()
		var sprites = $sprites
		remove_child(sprites)
		
		var body_vfx = VfxManager.play_vfx("enemy_body", global_position)
		body_vfx.add_child(sprites)
		body_vfx.vel = knockback.normalized() * 300 + Vector2(0, -100)
		
func flash():
	$sprites/sprite.material.set("shader_parameter/flash", 1.0)
	$flash_timer.start()
	
func _on_flash_timer_timeout():
	$sprites/sprite.material.set("shader_parameter/flash", 0.0)


func _on_attack_timer_timeout():
	attacking = true
	$AnimationPlayer.play("attack")
	await get_tree().create_timer(3).timeout
	attacking = false
	$AnimationPlayer.play("idle")
