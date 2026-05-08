extends Node2D
class_name Item


@onready var anim_player = get_node("collect anim")
@onready var particles = get_node("particles")
@onready var sprite = get_node("Box")
@onready var label = get_node("Label")


@export var item_name = "Item"
var item_collected = false


func _ready() -> void:
	label.text = item_name


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
