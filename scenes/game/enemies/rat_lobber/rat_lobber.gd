extends CharacterBody2D

var hp := 3
var knockback := Vector2.ZERO
var attacking = false

const bullet = preload("res://scenes/game/enemy_projectiles/enemy_bullet.tscn")

func _process(delta):
	
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

func shoot():
	for i in 3:
		var bullet_node = bullet.instantiate()
		
		get_parent().add_child(bullet_node)
		
		bullet_node.global_position = $sprites/sprite/tail/target/rock.global_position
		var difference = Global.player_position - global_position
		bullet_node.velocity = (difference.normalized() * randf_range(48, 96)).rotated((randf() * 2 - 1) * 0.6)
