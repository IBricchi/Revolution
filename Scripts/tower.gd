extends Area2D

func _ready():
	$icon.connect("button_up", self, "_tower_placed")

var follow_mouse: bool = false

func _input(event):
	if follow_mouse and event is InputEventMouseMotion:
		position = event.position - Vector2(32,32)

func set_icon(in_icon):
	$icon.icon = in_icon

func _tower_placed():
	if on_valid_position():
		$icon.disconnect("button_up", self, "_tower_palced")
		follow_mouse = false

func on_valid_position():
	return true
