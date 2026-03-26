extends Control


@onready var special_tilemap = get_node("/root/Node2D/special")
@onready var container = get_node("HBoxContainer")


var star_count = 0
var full_star = preload("res://star full.png")
var empty_star = preload("res://star empty.png")

var stars_collected = []


func restart_stars() -> void:
	star_count = 0
	for star_index in stars_collected:
		var star = special_tilemap.get_child(star_index)
		star.respawn()
	
	
	for star_sprite_parent in container.get_children():
		star_sprite_parent.get_child(0).texture = empty_star
	
	
	stars_collected.clear()


func new_star(star_index: int) -> void:
	stars_collected.append(star_index)
	star_count += 1
	container.get_node(str(star_count)+"/Sprite2D").texture = full_star


func save_stars() -> void:
	Global.save_stars(star_count)
