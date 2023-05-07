extends Sprite2D

var velocity : Vector2

func _process(delta):
	global_position += velocity * delta
	rotation = velocity.angle()

func _on_timer_timeout(): queue_free()
