extends Node2D
class_name Laser
##Is using RayCast2D to determine collision in a straight line 
##and a Line2D to draw the laser and CPUParticles2D to show where it collides.
##If it collides with a robot, it calls the die() function on the robot.
##It turns on and off in a given interval.

##Determine if the laser starts on or off.
@export var start_active: bool = true
##Determine how many turns the laser will be on. 1 turn is tilesize / robotspeed, the time it takes for the robot to move one tile
@export var laser_on_turns_interval: int = 2
##Determine how many turns the laser will be off. 1 turn is tilesize / robotspeed, the time it takes for the robot to move one tile
@export var laser_off_turns_interval: int = 2

##How long in seconds the laser will be on.
var laser_on_time_interval = 0.64
##How long in seconds the laser will be off.
var laser_off_time_interval = 0.64

##The RayCast2D child of this node.
@onready var raycast = get_node("raycast")
##The CPUParticles2D child of this node.
@onready var particles = get_node("particles")
##The Line2D child of this node.
@onready var line = get_node("line")
##The Timer child of this node.
@onready var timer = get_node("timer")

##Whether the laser is active or not.
var active = start_active


func _ready() -> void:
	var robot_speed = float(Robot.get_speed())
	var tile_size = get_node("/root/Node2D/ground").tile_set.tile_size.x
	
	laser_on_time_interval = (laser_on_turns_interval/robot_speed) * tile_size
	laser_off_time_interval = (laser_off_turns_interval/robot_speed) * tile_size
	
	ready_timer()


func _physics_process(_delta: float) -> void:
	if not active:
		return
	
	if raycast.is_colliding():
		check_collision()


##Changes the state of the laser to be ready to start, but does not start the laser.
func ready_timer() -> void:
	if start_active:
		turn_on()
		timer.set_wait_time(laser_on_time_interval)
		return
	
	turn_off()
	timer.set_wait_time(laser_off_time_interval)


##Checks the collision and updates the laser visually.
func check_collision() -> void:
	raycast.force_raycast_update()
	var raycast_point = raycast.get_collision_point()
	visual_change(raycast_point)
	check_raycast_collider()


##Updates the lasers visuals.
func visual_change(collision_point: Vector2) -> void:
	particles.global_position = collision_point
	line.points[1] = (collision_point - position).rotated(-rotation)

##Check if the robot is hit by the raycast.
func check_raycast_collider() -> void:
	var raycast_collider = raycast.get_collider()
	if raycast_collider is Robot:
		if raycast_collider.died:
			return
		
		raycast_collider.die()

##Start the timer for the laser
func start() -> void:
	if start_active:
		timer.start(laser_on_time_interval)
		return
	timer.start(laser_off_time_interval)

##Reset the laser
func reset() -> void:
	timer.stop()
	ready_timer()

##Turn off the laser.
func turn_off() -> void:
	active = false
	line.hide()
	raycast.set_enabled(false)
	particles.emitting = false

##Turn on the laser.
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
