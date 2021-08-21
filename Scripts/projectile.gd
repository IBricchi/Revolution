extends Area2D

var target: Node2D = null
var move_dir: Vector2
var speed: float = 200
var power: int = 1
var hit_limit: int = 1
var time_limit: float = -1

func _ready():
	connect("area_entered", self, "_entered")

func _physics_process(delta):
	if target != null:
		position += move_dir * delta * speed
		check_timer(delta)

func _entered(obj):
	if obj.is_in_group("enemy"):
		damage(obj)
		check_hit()

func damage(obj):
	obj.damage(power)
	
func check_hit():
	if hit_limit != -1:
		hit_limit -= 1
		if hit_limit == 0:
			del()

func set_target(in_target):
	target = in_target
	move_dir = (target.global_position - global_position).normalized()
	rotation = (-move_dir).tangent().angle()

func set_death_timer(time):
	time_limit = time

func check_timer(delta):
	if time_limit == -1:
		pass
	time_limit -= delta
	if time_limit <= 0:
		del()

func del():
	get_parent().remove_child(self)
	queue_free()
