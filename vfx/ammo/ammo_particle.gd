extends Sprite2D

const sprites = {
	"shell" : preload("res://vfx/ammo/shell.png"),
	"small_case" : preload("res://vfx/ammo/case.png")
}

@onready var vel = Vector2(randf_range(-12, 12), randf_range(-48, -128))

var start_y_pos = 0
var elevation = 14 + randf() * 4

func _ready():
	start_y_pos = global_position.y

func reset_texture(tex : String):
	texture = sprites[tex]

func _process(delta):
	vel.y += delta * 300
	global_position += vel * delta
	
	
	if global_position.y - start_y_pos > elevation:
		global_position.y = start_y_pos + elevation
		vel.y *= -0.5
	
	rotation += abs(vel.y * 0.005)
