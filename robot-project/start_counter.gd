extends Control


var star_count = 0
var full_star = preload("res://star full.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func new_star():
	star_count += 1
	get_node("HBoxContainer/"+str(star_count)+"/Sprite2D").texture = full_star


func save_stars():
	#change to correct level
	get_node("/root/Global").stars["level1"] = star_count
