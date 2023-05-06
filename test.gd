extends Node2D

var delta_pos = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _process(delta):
	var returned = VfxManager.spring_physics($Icon.global_position, Vector2(512, 300), delta_pos, 4, 10)
	delta_pos = returned.delta
	$Icon.global_position = returned.value
	
	if Input.is_action_just_pressed("lclick"):
		$Icon.global_position = get_global_mouse_position()
		
		VfxManager.frame_freeze(0.5)
