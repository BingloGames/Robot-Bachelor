extends StaticBody2D
class_name Door
##A door that can be opened and closed, only suppose to be used in a singelplayer setting.

##Color of the door. Only supports red and blue.
@export_enum("red", "blue") var color: String = "red"
##Direction of the door. Supports vertical and horisontal.
@export_enum("vertical", "horisontal") var dir: String = "vertical"

##The sprite child of this node.
@onready var sprite_node = get_node("Sprite2D")
##The collision shape child of this node.
@onready var collision_shape_node = get_node("CollisionShape2D")
##The animation player child of this node.
@onready var anim_player_node = get_node("AnimationPlayer")

##The text edit for the game.
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
	
	
	sprite_node.texture = load("res://components/singleplayer/door/"+sprite+".png")


##Play the open door animation and disable collision.
func open() -> void:
	collision_shape_node.call_deferred("set_disabled", true)
	print("anim path: ", anim_player_node.get_path())
	anim_player_node.play("open door anim")
	code_node.running_code = false

##Play the close door animation and enable collision.
func close() -> void:
	collision_shape_node.call_deferred("set_disabled", false)
	anim_player_node.play("close door anim")
	code_node.running_code = false

##Resumes the game when the door is ready. Automatically called when the door animation is finished. 
func finished() -> void:
	code_node.running_code = true

##Resets the door sprite and collision.
func reset() -> void:
	sprite_node.frame = 0
	collision_shape_node.call_deferred("set_disabled", false)
	
