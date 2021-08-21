extends Node2D

var enemies = []

var castle_hitpoints : int = 100
export var money : int = 500 setget set_money

onready var wavetimer : Timer = $WaveTimer
onready var ysort : YSort = $"Enemies Ysort"
onready var path1 : Path2D = $"First Path"
onready var path2 : Path2D = $"Second Path"
onready var path3 : Path2D = $"Third Path"
onready var ui : Node = $"ui"

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
	
		

	
	
func wave_start(): 
	set_money(money + Global.wave_number * 50)
	if castle_hitpoints > 0 : 
		Global.wave_number += 1
	var peasant_number = Global.wave_number * 3
	
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
		
		
		
		yield(get_tree().create_timer(0.25), "timeout")
		
	

func game_over():
	get_tree().change_scene("res://Scenes/death_screen.tscn")

func set_money(newval):
	money = newval
	ui.display_money(newval)
