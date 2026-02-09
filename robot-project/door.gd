extends StaticBody2D


func open() -> void:
	get_node("CollisionShape2D").call_deferred("set_disabled", true)
	get_node("AnimationPlayer").play("open door anim")


func close() -> void:
	get_node("CollisionShape2D").call_deferred("set_disabled", false)
	get_node("AnimationPlayer").play_backwards("open door anim")


func finished() -> void:
	get_node("/root/Node2D/code").running_code = true
