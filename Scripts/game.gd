extends Node2D

var wave_number : int = 0 

var enemies = []

onready var wavetimer : Timer = $WaveTimer
onready var ysort : YSort = $"Enemies Ysort"
onready var path1 : Path2D = $"First Path"
onready var path2 : Path2D = $"Second Path"
onready var path3 : Path2D = $"Third Path"

var peasant : Resource = preload("res://Scenes/Peasant.tscn")
var peasantpath : Resource = preload("res://Scenes/PeasantPath.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	wavetimer.one_shot = false
	wavetimer.start(4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_WaveTimer_timeout():
	wave_start()
	
	
func wave_start(): 
	wave_number += 1
	var peasant_number = wave_number * 3
	
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
		
		
		peas.translate(Vector2(rand_range(-3,3) , rand_range(-3,3)))
		yield(get_tree().create_timer(0.1), "timeout")




