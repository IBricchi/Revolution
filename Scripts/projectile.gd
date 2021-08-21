extends Area2D

var target: Node2D = null
var move_dir: Vector2
var speed: float = 200 setget set_speed
var power: int = 1 
var time_limit: float = 5

func _ready():
	connect("body_entered", self, "_entered")
	
func set_speed(val):
	speed = val

func _physics_process(delta):
	if target != null:
		position += move_dir * delta * speed
		check_timer(delta)

func _entered(obj):
	if obj.is_in_group("enemy"):
		damage(obj)

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
	if time_limit <= 0:
		del()

var can_die: bool = true
func del():
	if can_die:
		can_die = false
		get_parent().remove_child(self)
		queue_free()
