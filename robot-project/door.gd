extends StaticBody2D


@export_enum("red", "blue") var color: String = "red"
@export_enum("vertical", "horisontal") var dir: String = "vertical"


func _ready() -> void:
	var sprite = null
	
	if color == "red":
		sprite = "red door "
	else:
		sprite = "blue door "
	
	
	if dir == "vertical":
		sprite += "1"
	else:
		sprite += "2"
	
	
	get_node("Sprite2D").texture = load("res://"+sprite+".png")



func open() -> void:
	get_node("CollisionShape2D").call_deferred("set_disabled", true)
	get_node("AnimationPlayer").play("open door anim")


func close() -> void:
	get_node("CollisionShape2D").call_deferred("set_disabled", false)
	get_node("AnimationPlayer").play_backwards("open door anim")


func finished() -> void:
	get_node("/root/Node2D/code").running_code = true


func reset() -> void:
	get_node("Sprite2D").frame = 0
	get_node("CollisionShape2D").call_deferred("set_disabled", false)
	
