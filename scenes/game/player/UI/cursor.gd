extends Sprite2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _process(delta):
	global_position = get_global_mouse_position()
