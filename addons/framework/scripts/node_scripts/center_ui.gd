extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	position -= size * 0.5
	pivot_offset = size * 0.5
