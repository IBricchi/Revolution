extends CollisionShape2D

var color_mode: int = 1

func _draw():
	if color_mode == 1:
		draw_circle(Vector2.ZERO, shape.radius, Color(0,0,0,0.5))
	elif color_mode == 2:
		draw_circle(Vector2.ZERO, shape.radius, Color(1,0,0,0.5))
