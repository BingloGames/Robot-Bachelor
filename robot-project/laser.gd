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
		var raycast_collider = raycast.get_collider()
		var raycast_point = raycast.get_collision_point()
		particles.global_position = raycast_point
		line.points[1] = (raycast_point - position).rotated(-rotation)
		
		
		if raycast_collider is Robot:
			raycast_collider.die()


func start():
	timer.start(laser_time_interval)
func reset():
	timer.stop()
	turn_on()


func turn_off():
	active = false
	line.hide()
	raycast.set_enabled(false)
	particles.emitting = false


func turn_on():
	active = true
	line.show()
	raycast.set_enabled(true)
	particles.emitting = true


func _on_timer_timeout() -> void:
	print("timer timeout: ", laser_time_interval)
	if active:
		turn_off()
		return
	turn_on()
