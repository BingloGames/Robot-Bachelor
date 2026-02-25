extends Control


var base_functions = ["forward()", "backward()", "left()", "right()"]


var codeLines = []
@export var line_limit: int = 5

var robot = ""
@onready var text_edit = get_node("TextEdit")
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
	get_node("line limit").text += str(line_limit)
	var robot = get_node("/root/Node2D/robot")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waiting:
		return
	if not running_code:
		robot.idle()
		return
	
	if codeLines.is_empty():
		robot.check_end()
		running_code = false
		return
	
	
	if for_looping:
		#print("at start of continue for loop")
		continue_for_loop()
		
		#still for looping?
		if for_looping:
			#print("still for looping, so exiting")
			return
		if len(codeLines) == 0:
			#print("ended with a loop. exiting")
			return
		#else:
			#print("for loop ended, so stopping")
	
	
	var code = codeLines.pop_front()
	run_line(code)


func stop_running_code() -> void:
	waiting = false
	running_code = false
	
	get_node("Button").set_disabled(false)
	
	codeLines.clear()
	
	for_looping = false
	for_loop_count = 0
	for_loop_line = 0
	for_loop_contents.clear()
	for_loop_max = 0
	for_loop_string = ""
	
	variables.clear()
	for_loop_variables.clear()


func run_line(code) -> void:
	var code_split = code.split(" ", false)
	
	
	var validation_array = code_validator(code, code_split)
	var validation = validation_array[0]
	var error_message = validation_array[1]
	
	
	if not validation or error_message == "No code":
		print("Error: ", error_message)
		return
	
	
	if code_split[0] == "for":
		if for_looping:
			#print("starting a for loop inside a for loop. What to do if nested loop?")
			return
		start_for_loop(code_split, code)
		return
	
	
	run_base_functions(code)


func start_for_loop(code_split: Array[String], code: String) -> void:
	#print("For loop start!")
	
	#for loop already validated, so we know this works
	var range_split = code_split[3].split("(", false) #should have range_split[0] = "range", range_split[1] = "n):"
	var after_range_split = range_split[1].split(")", false) # should have after_range_split[0] = "n", after_range_split[1] = ":"
	for_loop_max = after_range_split[0].to_int()
	
	
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
	#print("for loop contents: ", for_loop_contents)
	continue_for_loop()


func continue_for_loop() -> void:
	#print("for looping!")
	if for_loop_line >= len(for_loop_contents):
		for_loop_line = 0
		for_loop_count += 1
		
		
		if for_loop_count >= for_loop_max: #verify if correct?
			#print("for loop end!")
			
			#remove the codeLines in the for loop that just ended
			for i in range(len(for_loop_contents)):
				codeLines.pop_front()
			#print("codeLines: ", codeLines)
			
			#reset for loop variables
			for_looping = false
			for_loop_count = 0
			for_loop_contents.clear()
			for_loop_max = 0
			for_loop_string = ""
			for_loop_variables.clear()
			return
	
	
	#print("run line in for loop")
	var code_line = for_loop_contents[for_loop_line]
	#print("code line: ", code_line)
	run_line(code_line)
	for_loop_line += 1


func run_base_functions(code) -> void:
	if not code in base_functions:
		print("wrong!")
		print(code)
		return
	
	
	code = code.replace("()", "")
	
	
	robot.call(code)
	waiting = true


func code_validator(code: String, code_split: Array[String]) -> Array:
	if code_split.is_empty():
		return[true, "No code"]
	
	if code_split[0] == "for":
		if for_looping:
			#print("starting a for loop inside a for loop. What to do if nested loop?")
			return [false, "Nested loop"]
		
		
		return for_loop_validator(code_split)
	return base_func_validator(code)


func base_func_validator(code: String) -> Array:
	if not code in base_functions:
		return [false, "Unknown function: " + code]
	return [true, code]


func for_loop_validator(code_split: Array[String]) -> Array:
	print("For loop start!")
	if not len(code_split) == 4:
		#print("Syntax error!")
		return [false, "Syntax error!"]
	
	
	if code_split[1] in variables.keys():
		#print("Error! Variable: ",str(code_split[1]) ,"in for loop already exist")
		return [false, "Error! Variable: " + str(code_split[1]) + "in for loop already exist"]
	
	
	if not code_split[2] == "in":
		#print("Syntax error! (no 'in' or 'in' at wrong place)")
		return [false, "Syntax error! (no 'in' or 'in' at wrong place)"]
	
	
	if code_split[3].begins_with("range(") and code_split[3].ends_with("):"):
		#print("For looping in range!")
		
		var range_split = code_split[3].split("(", false) #should have range_split[0] = "range", range_split[1] = "n):"
		var after_range_split = range_split[1].split(")", false) # should have after_range_split[0] = "n", after_range_split[1] = ":"
		
		
		if not after_range_split[0].is_valid_int():
			#print("Syntax error! (error inside range())")
			return [false, "Syntax error! (error inside range())"]
			
	else:
		#print("Invalid syntax with range. May still be valid, but no support yet") #for example "for item in list:"
		#print("code split[3]: ", code_split[3])
		return [false, "Invalid syntax with range!"]
	return [true, "success"]


func _on_button_pressed() -> void:
	get_node("Button").set_disabled(true)
	codeLines.clear()
	var x = 0
	var for_loop_length = 0
	for i in range(text_edit.get_line_count()):
		var ind = text_edit.get_indent_level(i)
		var line = text_edit.get_line(i)
		if line.is_empty():
			continue
		
		if ind == 0:
			codeLines.append(line)
			for_loop_length = 0
		else:
			for_loop_length += 1
			var y = x-for_loop_length
			var prevLine = codeLines[y]
			var lines = prevLine + line
			codeLines.append(lines)
		
		x += 1
	print(codeLines)
	running_code = true


func _on_lines_edited_from(from_line: int, to_line: int) -> void:
	var valid_lines = 0
	for i in range(text_edit.get_line_count()):
		if text_edit.get_line(i).strip_edges().is_empty():
			continue
		valid_lines += 1
	
	
	if valid_lines > line_limit:
		text_edit.remove_line_at(to_line)
		return
	
	
	get_node("Timer").start()
	
	
	if not from_line+1 == to_line:
		return
	
	
	var old_line = text_edit.get_line(from_line)
	var old_line_split = old_line.split(" ")
	var for_loop_valid = for_loop_validator(old_line_split)
	
	
	if for_loop_valid[0] or old_line.begins_with("\t"):
		text_edit.set_line(to_line, "\t")
		
		
		#set line only updates the text internally, so we need to wait until after the frame is done to update the caret
		await get_tree().process_frame
		text_edit.set_caret_column(len(text_edit.get_line(to_line)))


func _on_timer_timeout() -> void:
	var errors_text = []
	
	for i in range(get_node("TextEdit").get_line_count()):
		var line = get_node("TextEdit").get_line(i)
		
		
		line = line.strip_edges()
		var line_split = line.split(" ", false)
		
		
		var validation_array = code_validator(line, line_split)
		var validation = validation_array[0]
		var error_message = validation_array[1]
		
		if validation:
			get_node("TextEdit").set_line_background_color(i, Color(0, 0, 0, 0))
			continue
		
		get_node("TextEdit").set_line_background_color(i, Color(255,0,0))
		errors_text.append(error_message)
		print("Error: ", error_message)
	
	
	if errors_text.is_empty():
		get_node("error message").text = ""
		return
	
	
	var full_error = ""
	for error in errors_text:
		if not full_error.is_empty():
			full_error += "\n"
		full_error += error
	
	
	get_node("error message").text = full_error
