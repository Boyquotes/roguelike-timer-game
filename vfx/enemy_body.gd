extends Node2D

var vel := Vector2.ZERO


func _process(delta):
	vel.y += 400 * delta
	vel -= vel * delta * 1.5
	
	global_position += vel * delta
	
	rotation += vel.x * 0.001
	
	$fly_particles.global_rotation = 0
