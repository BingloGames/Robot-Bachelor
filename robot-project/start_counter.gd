extends Control


var star_count = 0
var full_star = preload("res://star full.png")
var empty_star = preload("res://star empty.png")

var stars_collected = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func restart_stars():
	star_count = 0
	for star in stars_collected:
		star.respawn()
	
	for star_sprite_parent in get_node("HBoxContainer").get_children():
		star_sprite_parent.get_child(0).texture = empty_star


func new_star(star_node):
	stars_collected.append(star_node)
	star_count += 1
	get_node("HBoxContainer/"+str(star_count)+"/Sprite2D").texture = full_star


func save_stars():
	#change to correct level
	get_node("/root/Global").stars["level1"] = star_count
