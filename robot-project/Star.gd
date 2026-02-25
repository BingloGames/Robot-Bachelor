extends Node2D
class_name Star

var collected = false


func respawn() -> void:
	get_node("AnimationPlayer").stop()
	scale = Vector2(1,1)
	get_node("Star").position = Vector2(0,0)
	get_node("Star").scale = Vector2(0.6,0.6)
	collected = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if collected:
		return
	
	
	if body is MultiplayerRobot:
		pass
		#add new star to all players
	
	get_node("/root/Node2D/star counter").new_star(self)
	get_node("AnimationPlayer").play("collect")
	collected = true
