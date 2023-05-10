extends Node

var time := .0
var player_position

func _process(delta):
	
	if Engine.is_editor_hint(): return
	
	time += delta
