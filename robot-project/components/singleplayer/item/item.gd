extends Node2D
class_name Item
##Pickable item, used for functions, variables, lists and any other text we want the Robot to pick up and show in the Item List.

##The animation player child of this node.
@onready var anim_player = get_node("collect anim")
##The particles child of this node.
@onready var particles = get_node("particles")
##The sprite child of this node.
@onready var sprite = get_node("Box")
##The label child of this node.
@onready var label = get_node("Label")

##The contents of the picked up item. This variable is what will be shown in Item List.
@export var item_name = "Item"
##If the item has been picked up or not.
var item_collected = false

func _ready() -> void:
	label.text = item_name

##Makes the item reapear if the level is restarted.
func respawn() -> void:
	anim_player.stop()
	particles.hide()
	sprite.scale = Vector2(0.8, 0.8)
	label.modulate.a = 0
	item_collected = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Robot:
		return
	if item_collected:
		return
	
	particles.show()
	particles.emitting = true
	anim_player.play("collect")
	item_collected = true
	
	get_parent().new_item(self.get_path())
