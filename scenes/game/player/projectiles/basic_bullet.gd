extends Sprite2D

var velocity : Vector2
var damping  := .0
var lifetime := 10.0

func _ready():
	$death_timer.wait_time = lifetime
	$death_timer.start()

func _process(delta):
	global_position += velocity * delta
	rotation = velocity.angle()
	
	velocity -= velocity * delta * damping
	
	material.set("shader_parameter/dir", velocity.length() * 0.00025 * Vector2.RIGHT)

func _on_death_timer_timeout():
	$AnimationPlayer.play("die")
	await get_tree().create_timer(0.1).timeout
	queue_free()
