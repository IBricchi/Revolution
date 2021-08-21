extends Area2D

func _ready():
	connect("area_entered", self, "_on_enter")
	connect("area_exited", self, "_on_exit")

func _on_enter(obj):
	if obj.is_in_group("tower"):
		obj.get_parent().is_active = true

func _on_exit(obj):
	if obj.is_in_group("tower"):
		obj.get_parent().is_active = false
