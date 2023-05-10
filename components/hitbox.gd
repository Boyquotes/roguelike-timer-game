extends Area2D

var attack : Attack
@export var active = true

signal hit_something

func _on_area_entered(area):
	if !active: return
	if !area.is_in_group("hurtbox"): return
	if area.get_parent().is_queued_for_deletion(): return
	
	area.hit(attack)
	emit_signal("hit_something")
