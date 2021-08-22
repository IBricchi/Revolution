extends KinematicBody2D

var offset_from_path : Vector2 =  Vector2(rand_range(-6,6) , rand_range(-6,6)) 
onready var game : Node = $"/root/game"
onready var deathparticles : CPUParticles2D = $deathparticles
onready var damageparticles : CPUParticles2D = $damage_particles
onready var deathtimer = $deathtimer

var path_follow 

var move_direction = 0
var speed = rand_range(35,40)
var time_since_last_anim : float = 0
var time_between_animations : float = rand_range(0.15, 0.4)
var health = 1
var is_big : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if randf() < 0.04:
		is_big = true
		scale.x *= 2.5
		scale.y *= 2.5
		offset_from_path = Vector2(0 , -2)
		health *= 8
		speed -= 10
	visible = false
	speed += Global.wave_number * 1.5


func _physics_process(delta):
	time_since_last_anim += delta
	if time_since_last_anim > time_between_animations :
		time_since_last_anim = fmod(time_since_last_anim, time_between_animations)
		var rot = 18*randf()
		if rotation_degrees < 0 : 
			rotation_degrees = rot
		else: rotation_degrees = -rot
	MovementLoop(delta)
	if path_follow.get_unit_offset() > 0.995:
		arrived_at_castle()

func MovementLoop(delta : float) : 
	var prepos = path_follow.get_global_position()
	path_follow.set_offset(path_follow.get_offset() + speed * delta)
	var pos = path_follow.get_global_position()
	position = pos + offset_from_path
	visible = true
	move_direction = pos.angle_to_point(prepos)  
	if move_direction <= PI/ 2 and move_direction >= - PI / 2: 
		scale.x = -2.5 if is_big else -1 
	else:
		scale.x =  2.5 if is_big else  1 

func arrived_at_castle():
	game.enemies.erase(self)
	if is_big:
		game.castle_hitpoints -= 10 if is_big else 1
	self.queue_free()

func take_damage(ammount):
	damageparticles.emitting = true
	health -= ammount;
	if health <= 0:
		got_killed()

func set_remote_path(path : Node2D):
	path_follow = path

var can_die: bool = true;
func got_killed():
	if can_die:
		can_die = false
		game.enemies.erase(self)
		Global.enemies_defeated += 1
		game.money += 10 if is_big else 1

		deathparticles.emitting = true
		damageparticles.emitting = true
		deathtimer.start(0.5)


func _on_deathtimer_timeout():
	get_parent().remove_child(self)
	queue_free() 
