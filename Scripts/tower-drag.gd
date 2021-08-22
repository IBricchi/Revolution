tool
extends Button

const tower_scene: Resource = preload("res://Scenes/tower.tscn")

enum tt {
	House,
	Shop
}
const tt_icon = [
	"res://Assets/PNG/Default size/Structure/medievalStructure_17.png",
	"res://Assets/PNG/Default size/Structure/medievalStructure_18.png"
]
export (tt) var tower_type: int = 0 setget set_tower_type

func set_tower_type(new_val):
	tower_type = new_val
	icon = load(tt_icon[tower_type])
	

export var radius: int = 25
export var price : int = 15
export var shot_speed : float = 200
export var projectile_lifetime : float = 2
export var multiple_hits : bool = false
export var wait_time : float = 5

func _ready():
	connect("button_up", self, "_on_button_up")

func _on_button_up():
	var new_tower = tower_scene.instance()
	get_tree().get_root().add_child(new_tower)
	new_tower.follow_mouse = true
	new_tower.set_icon(icon)
	new_tower.set_rad(radius) 
	new_tower.set_price(price)
	new_tower.set_shot_speed(shot_speed)
	new_tower.set_projectile_lifetime(projectile_lifetime)
	new_tower.set_multiple_hits(multiple_hits)
	new_tower.set_wait_time(wait_time)
	
