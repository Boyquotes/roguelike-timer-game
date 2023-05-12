extends Sprite2D

@export var bullet_amount := 1
@export var automatic     := true
@export var bullet_speed  := 800.0
@export var firerate      := 8
@export var spread        := 5
@export var recoil        := 15.0
@export var damping       := 0.0
@export var lifetime      := 10.0
@export var speed_random  := 0.0
@export var projectile_scene : PackedScene
@export var knockback     := 150.0

@export var burst := 1
@export var burst_delay := .0

var bursts_left := 0
var current_burst_delay := .0

@export var shake_strength := 2
@export var ammo_particle := "shell"

var can_shoot = false
@onready var world  := get_parent().get_parent().get_parent()
@onready var player := get_parent().get_parent()
@onready var anchor := get_parent()
@onready var cursor := get_parent().get_parent().get_node("UI/cursor")

func _ready():
	$reload_timer.wait_time = 1.0 / firerate

func _process(delta):
	
	anchor.rotation = (get_global_mouse_position() - anchor.global_position).angle()
	
	if abs(get_shoot_angle()) > PI * 0.5:
		anchor.scale.y = -1
	else:
		anchor.scale.y = 1
	
	anchor.show_behind_parent = get_shoot_angle() < 0
	
	if pressed_shoot():
		bursts_left = burst
		$AnimationPlayer.play("shoot")
	
	current_burst_delay -= delta
	if should_shoot():
		shoot()
		current_burst_delay = burst_delay

func pressed_shoot():
	return (
		(Input.is_action_pressed("lclick") and automatic and can_shoot) or
		(Input.is_action_just_pressed("lclick") and can_shoot)
	)
	
func should_shoot():
	return bursts_left != 0 and current_burst_delay < 0

func get_shoot_angle():
	return anchor.rotation

func shoot():
	can_shoot = false
	bursts_left -= 1
	
	var barrel_end = $barrel_end.global_position
	
	# animation
	player.camera.shake(shake_strength, 8, 0.1, rad_to_deg(get_shoot_angle()))
	cursor.animate()
	VfxManager.play_vfx("gun_shoot", barrel_end, get_shoot_angle())
	
	# shooting
	for i in bullet_amount:
		var projectile = projectile_scene.instantiate()
		
		projectile.global_position = barrel_end
		projectile.velocity  = Vector2(bullet_speed, .0).rotated(get_shoot_angle())
		projectile.velocity  = projectile.velocity.rotated(deg_to_rad(randf_range(-spread * 0.5, spread * 0.5)))
		projectile.velocity  *= randf_range(1.0 - speed_random, 1.0 + speed_random)
		projectile.damping   = damping
		projectile.lifetime  = lifetime
		projectile.knockback = knockback
		
		world.add_child(projectile)
	
	player.knockback -= Vector2(recoil, 0).rotated(get_shoot_angle())
	
	$reload_timer.start()

func ejact_casing():
	var ammo_particle_node = VfxManager.play_vfx("ammo_particle", global_position)
	ammo_particle_node.reset_texture(ammo_particle)

func reload():
	can_shoot = true
