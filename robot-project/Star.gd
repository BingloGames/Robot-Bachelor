extends Node2D

var collected = false


func respawn():
	get_node("AnimationPlayer").stop()
	scale = Vector2(1,1)
	get_node("Star").position = Vector2(0,0)
	get_node("Star").scale = Vector2(0.6,0.6)
	collected = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if collected:
		return
	
	
	get_node("/root/Node2D/star counter").new_star(self)
	get_node("AnimationPlayer").play("collect")
	collected = true
