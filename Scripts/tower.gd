extends Node2D

func _ready():
	$icon.connect("button_up", self, "_tower_placed")
	
	$col.connect("area_entered", self, "_on_col_enter")
	$col.connect("area_exited", self, "_on_col_exit")
	$col.connect("body_entered", self, "_on_col_enter")
	$col.connect("body_exited", self, "_on_col_exit")
	
	$rad.connect("body_entered", self, "_on_rad_enter")
	$rad.connect("body_exited", self, "_on_rad_exit")

var follow_mouse: bool = false
var in_valid_pos: bool = false
var price : int
var shot_speed : float
var projectile_lifetime : float
var multiple_hits : bool 
var is_active: bool = false
var wait_time_max: float = 5
var wait_time: float = 0
var power: int = 1
var proj_color: Color = Color.purple

func set_wait_time(val):
	wait_time_max = val

func set_multiple_hits(val):
	multiple_hits = val
	
func set_pos(gp):
	global_position = gp

func set_icon(in_icon):
	$icon.icon = in_icon

func set_power(in_power):
	power = in_power

func set_rad(in_rad):
	$rad/rad.shape.radius = in_rad
	
func set_price(newprice):
	price = newprice
	
func set_shot_speed(val):
	shot_speed = val

func set_projectile_lifetime(val):
	projectile_lifetime = val

func set_color(color):
	proj_color = color

var in_col: Array = []
func _on_col_enter(obj):
	in_col.push_back(obj)
func _on_col_exit(obj):
	var pos = in_col.find(obj)
	if pos != -1:
		in_col.remove(pos)

func on_valid_position():
	for obj in in_col:
		if obj.is_in_group("tower") or obj.is_in_group("path"):
			return false
	return true

func _input(event):
	if follow_mouse :
		if event is InputEventMouseMotion:
			position = event.position
			if not in_valid_pos == on_valid_position():
				in_valid_pos = not in_valid_pos
				change_rad_color(in_valid_pos)
		elif ((event is InputEventMouseButton and # check if right click
			event.pressed and
			event.button_index == BUTTON_RIGHT) or
			(event is InputEventKey and # check for escape button
			event.pressed and
			event.scancode == KEY_ESCAPE)):
				get_parent().remove_child(self)
				queue_free()
	elif (event is InputEventMouseButton and
		event.pressed and
		event.button_index == BUTTON_LEFT):
			var evLocal: InputEvent = make_input_local(event)
			if not Rect2(Vector2(0,0),$col/col.scale).has_point(evLocal.position):
				self.tower_selected = false

func change_rad_color(new_val):
	$rad/rad.color_mode = 1 if in_valid_pos else 2
	$rad/rad.update()

func _tower_placed():
	if in_valid_pos and follow_mouse and $"/root/game".money >= price:
		$icon.disconnect("button_up", self, "_tower_placed")
		$icon.connect("button_up", self, "_tower_select")
		follow_mouse = false
		$rad/rad.color_mode = 0
		$rad/rad.update()
		$"/root/game".set_money($"/root/game".money - price)

var tower_selected: bool = false setget select_tower
func select_tower(new_val):
	tower_selected = new_val
	$rad/rad.color_mode = 1 if tower_selected else 0
	$rad/rad.update()

func _tower_select():
	self.tower_selected = not tower_selected	

var in_rad: Array = []
func _on_rad_enter(obj):
	in_rad.push_back(obj)
	
func _on_rad_exit(obj):
	var pos = in_rad.find(obj)
	if pos != -1:
		in_rad.remove(pos)


func _physics_process(delta):
	if is_active and not follow_mouse and wait_time <= 0:
		# largest int godot handles
		var min_idx: int = 9223372036854775807  # savage
		var target = null
		for obj in in_rad:
			if obj.is_in_group("enemy"):
				var idx: int = obj.get_index()
				if idx < min_idx:
					min_idx = idx
					target = obj
		if target != null:
			shoot_at(target)
			wait_time = wait_time_max
	else:
		wait_time -= 3 * delta if is_active else delta

const projectile = preload("res://Scenes/projectile.tscn")
func shoot_at(target):
	var proj = projectile.instance()
	add_child(proj)
	proj.set_target(target)
	proj.set_power(power)
	proj.set_multiple_hits(multiple_hits)
	proj.set_death_timer(projectile_lifetime)
	proj.set_color(proj_color)
