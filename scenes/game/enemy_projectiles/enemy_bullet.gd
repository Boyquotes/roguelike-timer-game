extends Sprite2D

var velocity : Vector2

func _process(delta):
	$glow.scale = 0.16 * (abs(sin(Global.time * 2)) * 0.2 + 0.8) * Vector2(1, 1)
	
	global_position += velocity * delta
