extends Area2D

var attack : Attack

func _on_area_entered(area):
	if area.is_in_group("hurtbox"):
		area.hit()
