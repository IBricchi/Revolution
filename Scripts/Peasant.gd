extends KinematicBody2D

var offset_from_path : Vector2 =  Vector2(rand_range(-6,6) , rand_range(-6,6)) 
onready var game : Node = $"/root/game"
onready var deathparticles : CPUParticles2D = $deathparticles
onready var damageparticles : CPUParticles2D = $damage_particles
onready var deathtimer = $deathtimer
onready var deathtimer2 = $deathtimer2
onready var deathaudio = $AudioStreamPlayer2D
onready var sprite = $Buffoon

var smalldeath1 : Resource = preload("res://Assets/Sounds/smalldeath1.ogg")
var smalldeath2 : Resource = preload("res://Assets/Sounds/smalldeath2.ogg")
var smalldeath3 : Resource = preload("res://Assets/Sounds/smalldeath3.ogg")
var smalldeath4 : Resource = preload("res://Assets/Sounds/smalldeath4.ogg")
var bigdeath1 : Resource = preload("res://Assets/Sounds/bigdeath1.ogg")
var bigdeath2 : Resource = preload("res://Assets/Sounds/bigdeath2.ogg")

var sounds = [smalldeath1,smalldeath2,smalldeath3,smalldeath4]
var selfdead : bool = false	
var path_follow 

var move_direction = 0
var speed = rand_range(40,50)
var time_since_last_anim : float = 0
var time_between_animations : float = rand_range(0.15, 0.4)
var health = 1
var is_big : bool = false

func _ready():
	if randf() < 0.12 and game.big_guy_number <= Global.wave_number:
		is_big = true
		game.big_guy_number += 1
		scale.x *= 2 
		scale.y *= 2 
		offset_from_path = Vector2(0 , -2)
		health *= int(rand_range(4,7))
		speed -= 15
		sounds = [bigdeath1,bigdeath2]
		time_between_animations += 0.15
		
		
		
	var sprite_prob = randf()
	if sprite_prob > 0.75:
		sprite.texture = load("res://Assets/PNG/Retina/Unit/medievalUnit_09.png")
		
	elif sprite_prob > 0.5:
		sprite.texture = load("res://Assets/PNG/Retina/Unit/medievalUnit_21.png" )
		speed += 15
		if is_big :
			health -= 2
		time_between_animations -= 0.05
	elif sprite_prob > 0.25:
		sprite.texture = load("res://Assets/PNG/Retina/Unit/medievalUnit_16.png")
		speed -= 10 if is_big else 15
		health += 1
	visible = false
	health += int(Global.wave_number / 4)


func _physics_process(delta):
	time_since_last_anim += delta
	if time_since_last_anim > time_between_animations :
		time_since_last_anim = fmod(time_since_last_anim, time_between_animations)
		var rot = 18*randf()
		if rotation_degrees < 0 : 
			rotation_degrees = rot
		else: rotation_degrees = -rot
	if not selfdead:
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
		scale.x = -2  if is_big else -1 
	else:
		scale.x =  2  if is_big else  1 

func arrived_at_castle():
	game.enemies.erase(self)
	game.castleaudio.play()
	game.castle_hitpoints -= 10 if is_big else 1
	self.queue_free()

func take_damage(ammount):
	deathaudio.stream = sounds[int(rand_range(0,len(sounds)))]
	deathaudio.play()
	damageparticles.emitting = true
	health -= ammount;
	if health <= 0:
		got_killed()

func set_remote_path(path : Node2D):
	path_follow = path

var can_die: bool = true;

func got_killed():
	if can_die:
		selfdead = true
		can_die = false
		game.enemies.erase(self)
		Global.enemies_defeated += 1
		game.money += int(rand_range(8,13)) if is_big else int(rand_range(1,3))

		deathparticles.emitting = true
		deathtimer.start(0.5)
		


func _on_deathtimer_timeout():
	# to allow audio to play
	visible = false
	deathparticles.emitting = false
	damageparticles.emitting = false
	position = Vector2(0,0)
	deathtimer2.start(1)

func _on_deathtimer2_timeout():
	get_parent().remove_child(self)
	queue_free() 
