extends Sprite2D

var velocity : Vector2
var damping  := .0
var lifetime := 10.0
var start_velocity
var knockback := 0.0

func _ready():
	$death_timer.wait_time = lifetime
	$death_timer.start()
	
	$hitbox.attack = Attack.new()
	$hitbox.attack.set("damage", 1)
	
	start_velocity = velocity

func _process(delta):
	global_position += velocity * delta
	rotation = velocity.angle()
	
	velocity -= velocity * delta * damping
	
	var vel_scale = start_velocity / velocity
	$hitbox.attack.damage = 1
	$hitbox.attack.knockback = velocity.normalized() * knockback
	
	material.set("shader_parameter/dir", velocity.length() * 0.00025 * Vector2.RIGHT)

func _on_death_timer_timeout():
	$AnimationPlayer.play("die")
	await get_tree().create_timer(0.1).timeout
	queue_free()


func _on_hitbox_hit_something():
	VfxManager.play_vfx("basic_bullet_hit", global_position, velocity.angle())
	queue_free()
