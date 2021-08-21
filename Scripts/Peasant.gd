extends KinematicBody2D


onready var path_follow = get_parent()

var move_direction = 0
var speed = 30
var time_since_last_anim : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	time_since_last_anim += delta
	if time_since_last_anim > 0.7 :
		time_since_last_anim = fmod(time_since_last_anim, 0.7)
		var rot = 18*randf()
		if rotation_degrees < 0 : 
			rotation_degrees = rot
		else: rotation_degrees = -rot
		
	MovementLoop(delta)

func MovementLoop(delta : float) : 
	var prepos = path_follow.get_global_position()
	path_follow.set_offset(path_follow.get_offset() + speed * delta)
	var pos = path_follow.get_global_position()	
	move_direction = (pos.angle_to_point(prepos) / PI)*180
	
