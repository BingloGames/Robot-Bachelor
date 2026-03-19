extends Control


var star_count = 0
var full_star = preload("res://star full.png")
var empty_star = preload("res://star empty.png")

var stars_collected = []


func restart_stars() -> void:
	star_count = 0
	for star_index in stars_collected:
		var star = get_node("/root/Node2D/special").get_child(star_index)
		star.respawn()
	
	
	for star_sprite_parent in get_node("HBoxContainer").get_children():
		star_sprite_parent.get_child(0).texture = empty_star
	
	
	stars_collected.clear()


func new_star(star_index) -> void:
	stars_collected.append(star_index)
	star_count += 1
	get_node("HBoxContainer/"+str(star_count)+"/Sprite2D").texture = full_star


func save_stars() -> void:
	Global.save_stars(star_count)
