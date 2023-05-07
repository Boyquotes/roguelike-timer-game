extends Sprite2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta):
	global_position = get_global_mouse_position()
	scale = lerp(scale, Vector2(1, 1), delta * 12)

func animate():
	scale = Vector2(1.3, 1.3)
