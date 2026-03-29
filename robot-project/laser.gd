extends Node2D


@export var start_active: bool = true
@export var laser_on_turns_interval: int = 2
@export var laser_off_turns_interval: int = 2


var laser_on_time_interval = 0.64
var laser_off_time_interval = 0.64


@onready var raycast = get_node("raycast")
@onready var particles = get_node("particles")
@onready var line = get_node("line")
@onready var timer = get_node("timer")


var active = start_active


func _ready() -> void:
	#32 is the tile size and 100 is the robot speed
	laser_on_time_interval = (laser_on_turns_interval/100.0) * 32
	laser_off_time_interval = (laser_off_turns_interval/100.0) * 32
	
	
	ready_timer()


func _physics_process(_delta: float) -> void:
	if not active:
		return
	
	
	if raycast.is_colliding():
		check_collision()


func ready_timer() -> void:
	if start_active:
		turn_on()
		timer.set_wait_time(laser_on_time_interval)
		return
	
	
	turn_off()
	timer.set_wait_time(laser_off_time_interval)


func check_collision() -> void:
	raycast.force_raycast_update()
	var raycast_point = raycast.get_collision_point()
	visual_change(raycast_point)
	check_raycast_collider()


func visual_change(collision_point: Vector2) -> void:
	particles.global_position = collision_point
	line.points[1] = (collision_point - position).rotated(-rotation)


func check_raycast_collider() -> void:
	var raycast_collider = raycast.get_collider()
	if raycast_collider is Robot:
		if raycast_collider.died:
			print("robot already dead")
			return
		print("robot got hit by raycast at pos: ", raycast.get_collision_point())
		if name == "laser2":
			print("peer laser killed robot")
			print("hey")
		
		
		raycast_collider.die()


func start() -> void:
	if start_active:
		timer.start(laser_on_time_interval)
		return
	timer.start(laser_off_time_interval)


func reset() -> void:
	timer.stop()
	ready_timer()


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
		timer.start(laser_off_time_interval)
		return
	
	
	turn_on()
	timer.start(laser_on_time_interval)
