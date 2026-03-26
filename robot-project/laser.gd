extends Node2D


@export var laser_turns_interval: int = 2
var laser_time_interval = 0.64


@onready var raycast = get_node("raycast")
@onready var particles = get_node("particles")
@onready var line = get_node("line")
@onready var timer = get_node("timer")


var active = true


func _ready() -> void:
	#32 is the tile size and 100 is the robot speed
	laser_time_interval = (laser_turns_interval/100.0) * 32
	timer.wait_time = laser_time_interval


func _process(_delta: float) -> void:
	if not active:
		return
	
	
	if raycast.is_colliding():
		check_collision()


func check_collision() -> void:
	var raycast_point = raycast.get_collision_point()
	visual_change(raycast_point)
	check_raycast_collider()


func visual_change(collision_point: Vector2) -> void:
	particles.global_position = collision_point
	line.points[1] = (collision_point - position).rotated(-rotation)


func check_raycast_collider() -> void:
	var raycast_collider = raycast.get_collider()
	if raycast_collider is Robot:
		raycast_collider.die()


func start() -> void:
	timer.start(laser_time_interval)
func reset() -> void:
	timer.stop()
	turn_on()


func turn_off() -> void:
	active = false
	line.hide()
	raycast.set_enabled(false)
	particles.emitting = false


func turn_on() -> void:
	active = true
	line.show()
	raycast.set_enabled(true)
	particles.emitting = true


func _on_timer_timeout() -> void:
	if active:
		turn_off()
		return
	turn_on()
