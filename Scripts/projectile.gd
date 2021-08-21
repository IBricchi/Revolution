extends Area2D

var target: Node2D = null
var move_dir: Vector2
var speed: float = 100
var power: int = 1
var hit_limit: int = 1

func _ready():
	connect("area_entered", self, "_entered")

func _physics_process(delta):
	if target != null:
		position += move_dir*speed*delta

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
			queue_free()

func set_target(in_target):
	target = in_target
	move_dir = (target.global_position - global_position).normalized()
	look_at(position + move_dir)

func set_death_timer(time):
	var timer = Timer.new()
	self.add_child(timer)
	timer.connect("timeout", self, "queue_free")
	timer.set_wait_time(time)
	timer.start()