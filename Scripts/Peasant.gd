extends KinematicBody2D

var offset_from_path : Vector2 =  Vector2(rand_range(-6,6) , rand_range(-6,6)) 
onready var game : Node = $"/root/game"


var path_follow 

var move_direction = 0
var speed = 400
var time_since_last_anim : float = 0
var time_between_animations : float = rand_range(0.15, 0.4)
var health = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# set visible to false until first position is set to avoid
	# glitchy appearances at (0, 0) between instantiation and setting pos
	visible = false
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
	if path_follow.get_unit_offset() > 0.995:
		arrived_at_castle()

func MovementLoop(delta : float) : 
	var prepos = path_follow.get_global_position()
	path_follow.set_offset(path_follow.get_offset() + speed * delta)
	var pos = path_follow.get_global_position()
	position = pos + offset_from_path
	visible = true
	move_direction = pos.angle_to_point(prepos)  
	if move_direction <= PI/ 2 and move_direction >= - PI / 2 : 
		scale.x = -1
	else:
		scale.x = 1

func arrived_at_castle():
	game.enemies.erase(self)
	game.castle_hitpoints -= 1
	
	self.queue_free()

func take_damage(ammount):
	health -= ammount;
	if health <= 0:
		got_killed()

func set_remote_path(path : Node2D):
	path_follow = path
	
func got_killed():
	game.enemies.erase(self)
	Global.enemies_defeated += 1
	game.money += 5
	get_parent().remove_child(self)
	queue_free()
