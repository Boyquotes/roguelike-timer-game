extends Timer

@onready var parent_modulate = get_parent().modulate

func _ready():
	get_parent().modulate = Color(0, 0, 0)


func _on_timeout():
	get_parent().modulate = parent_modulate
	queue_free()
