extends KinematicBody2D


var path_follow 

var move_direction = 0
var speed = 25
var time_since_last_anim : float = 0
var time_between_animations : float = rand_range(0.15, 0.4)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _physics_process(delta):
	time_since_last_anim += delta
	if time_since_last_anim > time_between_animations :
		time_since_last_anim = fmod(time_since_last_anim, time_between_animations)
		var rot = 18*randf()
		if rotation_degrees < 0 : 
			rotation_degrees = rot
		else: rotation_degrees = -rot
	MovementLoop(delta)

func MovementLoop(delta : float) : 
	var prepos = path_follow.get_global_position()
	path_follow.set_offset(path_follow.get_offset() + speed * delta)
	var pos = path_follow.get_global_position()
	position = pos
	move_direction = pos.angle_to_point(prepos)  
	if move_direction <= PI/ 2 and move_direction >= - PI / 2 : 
		scale.x = -1
	else:
		scale.x = 1

func set_remote_path(path : Node2D):
	path_follow = path
