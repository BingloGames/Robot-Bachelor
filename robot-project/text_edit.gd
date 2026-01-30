extends TextEdit
var codeLines = []
@onready var robot = get_node("/root/Node2D/robot")
var waiting = false


var running_code = false


var for_looping = false
var for_loop_count = 0
var for_loop_line = 0
var for_loop_contents = []
var for_loop_max = 0
var for_loop_string = "" #every line in the for loop start with this. What about nested loops?


var variables = {} #variable_name : variable_value
var for_loop_variables = {} #what about nested loops?

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
	
	
	if for_looping:
		print("at start of continue for loop")
		continue_for_loop()
		
		#still for looping?
		if for_looping:
			print("still for looping, so exiting")
			return
		if len(codeLines) == 0:
			print("ended with a loop. exiting")
			return
		else:
			print("for loop ended, so stopping")
	
	
	var code = codeLines.pop_front()
	run_line(code)


func run_line(code):
	var code_split = code.split(" ", false)
	
	
	if code_split[0] == "for":
		if for_looping:
			print("starting a for loop inside a for loop. What to do if nested loop?")
			return
		start_for_loop(code_split, code)
	
	
	run_base_functions(code)


func start_for_loop(code_split, code):
	print("For loop start!")
	if not len(code_split) == 4:
		print("Syntax error!")
		return
	
	
	if code_split[1] in variables.keys():
		print("Error! Variable in for loop already exist")
		return
	
	
	if not code_split[2] == "in":
		print("Syntax error! (no 'in' or 'in' at wrong place)")
		return
	
	
	if code_split[3].begins_with("range(") and code_split[3].ends_with("):"):
		print("For looping in range!")
		
		var range_split = code_split[3].split("(", false) #should have range_split[0] = "range", range_split[1] = "n):"
		var after_range_split = range_split[1].split(")", false) # should have after_range_split[0] = "n", after_range_split[1] = ":"
		
		
		if not after_range_split[0].is_valid_int():
			print("Syntax error! (error inside range())")
			return
		
		
		for_loop_max = after_range_split[0].to_int()
	else:
		print("Invalid syntax with range. May still be valid, but no support yet") #for example "for item in list:"
		print("code split[3]: ", code_split[3])
		return
	
	
	for_loop_variables[code_split[1]] = 0 #usually i = 0
	for_loop_string = code
	for_looping = true
	
	#get every line in the for loop and add it to for_loop_contents
	var i = 0
	while true:
		var check_line = codeLines.get(i)
		
		#check_line does not exist
		if not check_line:
			break
		#check_line is not in the for loop
		if not check_line.begins_with(for_loop_string):
			break
		
		check_line = check_line.replace(for_loop_string, "")
		check_line = check_line.dedent()
		for_loop_contents.append(check_line)
		
		
		i += 1
	print("for loop contents: ", for_loop_contents)
	continue_for_loop()


func continue_for_loop():
	print("for looping!")
	if for_loop_line >= len(for_loop_contents):
		for_loop_line = 0
		for_loop_count += 1
		
		
		if for_loop_count >= for_loop_max: #verify if correct?
			print("for loop end!")
			
			#remove the codeLines in the for loop that just ended
			for i in range(len(for_loop_contents)):
				codeLines.pop_front()
			print("codeLines: ", codeLines)
			
			#reset for loop variables
			for_looping = false
			for_loop_count = 0
			for_loop_contents.clear()
			for_loop_max = 0
			for_loop_string = ""
			for_loop_variables.clear()
			return
	
	print("run line in for loop")
	var code_line = for_loop_contents[for_loop_line]
	print("code line: ", code_line)
	run_line(code_line)
	for_loop_line += 1


func run_base_functions(code):
	match code:
		"forward()":
			robot.forward()
		"backward()":
			robot.backward()
		"left()":
			robot.left()
		"right()":
			robot.right()
		_:
			print("wrong!")
			return
	
	
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
		else:
			var y = x-1
			var prevLine = codeLines[y]
			var lines = prevLine + line
			codeLines.append(lines)
		
		x += 1
	print(codeLines)
	running_code = true
