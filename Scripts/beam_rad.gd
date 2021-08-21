extends CollisionPolygon2D

func _physics_process(delta):
	rotation = (-(get_global_mouse_position() - global_position)).tangent().angle()

func _draw():
	draw_colored_polygon(PoolVector2Array([Vector2(-30,0),Vector2(30,0),Vector2(120,-800),Vector2(-120,-800)]), Color(0,1,1,0.3))
