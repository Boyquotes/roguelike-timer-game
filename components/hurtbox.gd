extends Area2D

var invonurable = false

func hit(attack):
	if invonurable: return
	
	get_parent().hit(attack)
