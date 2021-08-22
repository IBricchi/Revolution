extends Node2D

var enemies = []

var castle_hitpoints : int = 100 setget set_castle_hp
export var money : int = 60 setget set_money

onready var wavetimer : Timer = $WaveTimer
onready var ysort : YSort = $"Enemies Ysort"
onready var path1 : Path2D = $"First Path"
onready var path2 : Path2D = $"Second Path"
onready var path3 : Path2D = $"Third Path"
onready var ui : Node = $"ui"
onready var hpbar : Control = $HealthBar
onready var castleaudio = $AudioStreamPlayer2
var big_guy_number = 0

var peasant : Resource = preload("res://Scenes/Peasant.tscn")
var peasantpath : Resource = preload("res://Scenes/PeasantPath.tscn")
var wave_defeated : bool = false

func _ready():
	Global.wave_number = 0
	Global.enemies_defeated = 0
	randomize()
	wavetimer.one_shot = true
	wave_start()

func _process(delta):
	if castle_hitpoints <= 0 :
		game_over()
	if enemies.empty():
		wave_start()
		big_guy_number = 0

func wave_start(): 
	set_money(money + 40)
	if castle_hitpoints > 0 : 
		Global.wave_number += 1
	var peasant_number = int(Global.wave_number * 8)
	
	for i in range(peasant_number):
		var prob : float = randf()
		var remotepath = peasantpath.instance()
		var peas = peasant.instance()
		
		ysort.add_child(peas)
		enemies.append(peas)
		
		if prob < 0.33333: 
			path1.add_child(remotepath)
		elif prob < 0.66667:
			path2.add_child(remotepath)
		else:
			path3.add_child(remotepath)
		
		peas.set_remote_path(remotepath)
		
		yield(get_tree().create_timer(0.20), "timeout")


func game_over():
	var a = get_tree().get_root();
	var b = a.get_children();
	for obj in get_tree().get_root().get_children():
		if obj.is_in_group("tower"):
			obj.get_parent().remove_child(obj)
			obj.queue_free()
	get_tree().change_scene("res://Scenes/death_screen.tscn")

func set_money(newval):
	money = newval
	ui.display_money(newval)


func set_castle_hp(newval):
	castle_hitpoints = newval
	hpbar.display_health(newval)
