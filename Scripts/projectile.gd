extends Area2D

var target: Node2D = null
var move_dir: Vector2
var speed: float = 200 setget set_speed
var power: int = 1 
var time_limit: float = 5

onready var explosionparticles : CPUParticles2D = $ExplosionParticles

var multiple_hits : bool 

var can_die: bool = true
var can_hit: bool = true

func _ready():
	connect("body_entered", self, "_entered")
	
func set_speed(val):
	speed = val

func set_power(in_power):
	power = in_power

func set_multiple_hits(val):
	multiple_hits = val

func set_color(color):
	$CPUParticles2D.color = color

func _physics_process(delta):
	if target != null:
		position += move_dir * delta * speed
		if not can_hit:
			time_limit = min(time_limit, 0.1)
		check_timer(delta)

func _entered(obj):
	if obj.is_in_group("enemy"):
		damage(obj)
		if not multiple_hits:
			can_hit = false


func damage(obj):
	obj.take_damage(power)

func set_target(in_target):
	target = in_target
	move_dir = (target.global_position - global_position).normalized()
	rotation = (-move_dir).tangent().angle()

func set_death_timer(time):
	time_limit = time
	

func check_timer(delta):
	time_limit -= delta
	if time_limit < 0.3:
		explosionparticles.emitting = true
	if time_limit <= 0:
		del()

func del():
	if can_die:
		can_die = false
		get_parent().remove_child(self)
		queue_free()
