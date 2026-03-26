extends StaticBody2D


@export_enum("red", "blue") var color: String = "red"
@export_enum("vertical", "horisontal") var dir: String = "vertical"


@onready var sprite_node = get_node("Sprite2D")
@onready var collision_shape_node = get_node("CollisionShape2D")
@onready var anim_player_node = get_node("AnimationPlayer")


@onready var code_node = get_node("/root/Node2D/code")


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
	
	
	sprite_node.texture = load("res://"+sprite+".png")



func open() -> void:
	print("door opening")
	collision_shape_node.call_deferred("set_disabled", true)
	anim_player_node.play("open door anim")
	code_node.running_code = false


func close() -> void:
	collision_shape_node.call_deferred("set_disabled", false)
	anim_player_node.play("close door anim")
	code_node.running_code = false


func finished() -> void:
	code_node.running_code = true


func reset() -> void:
	sprite_node.frame = 0
	collision_shape_node.call_deferred("set_disabled", false)
	
