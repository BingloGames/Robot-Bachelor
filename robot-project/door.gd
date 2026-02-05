extends StaticBody2D


func open():
	get_node("CollisionShape2D").call_deferred("set_disabled", true)
	get_node("AnimationPlayer").play("open door")


func close():
	get_node("CollisionShape2D").call_deferred("set_disabled", false)
	get_node("AnimationPlayer").play_backwards("open door")
