extends TextEdit
var codeLines = []
@onready var robot = get_node("/root/Node2D/robot")
var waiting = false

var running_code = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waiting:
		return
	if not running_code:
		return
	
	
	if codeLines.is_empty():
		robot.check_end()
		return
	
	
	var code = codeLines.pop_front()
	
	match code:
		"forward()":
			robot.forward()
		"backward()":
			robot.backward()
		"left()":
			robot.left()
		"right()":
			robot.right()
	
	
	waiting = true


func _on_button_pressed():
	codeLines = []
	var x = 0
	for i in range(get_line_count()):
		var ind = get_indent_level(i)
		var line = get_line(i)
		if line.is_empty():
			continue
		
		if ind == 0:
			codeLines.append(line)
			x += 1
		else:
			var y = x-1
			var prevLine = codeLines[y]
			var lines = prevLine + line
			codeLines.append(lines)
	print(codeLines)
	running_code = true
