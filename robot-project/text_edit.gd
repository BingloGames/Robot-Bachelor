extends Control


@onready var text_edit = get_node("TextEdit")
@onready var go_button = get_node("GoButton")
@onready var stop_button = get_node("StopButton")
@onready var error_node = get_node("error message")


#update with language
var last_line_error = "Warning: Last line"
var code_stopped_text = "Code stopped"
var line_problem_text = "Problem at line: "
var no_code_error = "No code"
var nested_loop_error = "Nested loop"
var unknown_func_error = "Unknown function: "
var syntax_error = "Syntax error"
var for_loop_var_exists_error_1 = "Variable: "
var for_loop_var_exists_error_2 = " in for loop already exist"
var for_loop_in_error = "Syntax error (no 'in' or 'in' at wrong place)"
var inside_range_error = "Syntax error! (error inside range())"
var range_error = "Invalid syntax with range!"


var base_functions = ["forward()", "backward()", "left()", "right()", "wait()"]


var codeLines = []
@export var line_limit: int = 5

var robot = null
var waiting = false: set = set_waiting
@onready var turn = 0

var running_code = false


var for_looping = false
var for_loop_count = 0
var for_loop_line = 0
var for_loop_contents = []
var for_loop_max = 0
var for_loop_string = "" #every line in the for loop start with this. What about nested loops?


var variables = {} #variable_name : variable_value
var for_loop_variables = {} #what about nested loops?


func _ready() -> void:
	get_node("line limit").text += str(line_limit)
	robot = get_node("/root/Node2D/robots/robot")


func _process(_delta: float) -> void:
	if waiting:
		return
	if not running_code:
		robot.idle()
		return
	
	
	if codeLines.is_empty() and not for_looping:
		print("code lines is empty and not for looping")
		robot.check_end()
		running_code = false
		return
	
	
	run_code()


func run_code() -> void:
	if for_looping:
		if len(for_loop_contents) == 0:
			#stop_running_code()
			Global.restart_level()
		else:
			continue_for_loop()
			
		
		#still for looping?
		if for_looping:
			return
		if len(codeLines) == 0:
			return
	
	
	
	var code = codeLines.pop_front()
	print(robot.name, " code after this: ", codeLines)
	run_line(code)


func problem_warning() -> void:
	if turn == 0:
		error_node.set_text(code_stopped_text)
	else:
		error_node.set_text(line_problem_text+str(turn))
		text_edit.set_line_background_color(turn-1, Color(255,0,0))


func stop_running_code() -> void:
	turn = 0
	go_button.show()
	stop_button.hide()
	waiting = false
	running_code = false
	codeLines.clear()
	
	
	go_button.set_disabled(false)
	
	
	for_looping = false
	for_loop_count = 0
	for_loop_line = 0
	for_loop_contents.clear()
	for_loop_max = 0
	for_loop_string = ""
	
	
	variables.clear()
	for_loop_variables.clear()


func run_line(code: String) -> void:
	var code_split = code.split(" ", false)
	
	
	var validation_array = code_validator(code, code_split)
	var validation = validation_array[0]
	var error_message = validation_array[1]
	
	
	if not validation or error_message == no_code_error:
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
	#for loop already validated, so we know this works
	turn += 1
	var range_split = code_split[3].split("(", false) #should have range_split[0] = "range", range_split[1] = "n):"
	var after_range_split = range_split[1].split(")", false) # should have after_range_split[0] = "n", after_range_split[1] = ":"
	for_loop_max = after_range_split[0].to_int()
	
	for_loop_variables[code_split[1]] = 0 #usually i = 0
	for_loop_string = code
	for_looping = true
	
	
	for_loop_contents = codeLines.pop_front()
	print(len(for_loop_contents))
	#get every line in the for loop and add it to for_loop_contents
	#var i = 0
	#while true:
		#var check_line = codeLines.get(i)
		#
		##check_line does not exist
		#if not check_line:
			#break
		##check_line is not in the for loop
		#if not check_line.begins_with(for_loop_string):
			#break
		#
		#check_line = check_line.replace(for_loop_string, "")
		#check_line = check_line.dedent()
		#for_loop_contents.append(check_line)
		#
		#
		#i += 1

	
	
	if len(for_loop_contents) == 0:
		#stop_running_code()
		Global.restart_level()
	else:
		print(len(for_loop_contents))
		#turn -= len(for_loop_contents)
		continue_for_loop()


func continue_for_loop() -> void:
	if for_loop_line >= len(for_loop_contents):
		for_loop_line = 0
		for_loop_count += 1
		
		
		if for_loop_count >= for_loop_max: #verify if correct?
			#remove the codeLines in the for loop that just ended
			
			
			#reset for loop variables
			for_looping = false
			for_loop_count = 0
			for_loop_contents.clear()
			for_loop_max = 0
			for_loop_string = ""
			for_loop_variables.clear()
			return
		else:
			turn -= len(for_loop_contents)
	
	
	var code_line = for_loop_contents[for_loop_line].strip_edges()
	run_line(code_line)
	for_loop_line += 1


func run_base_functions(code: String) -> void:
	if not code in base_functions:
		print("wrong!")
		print(code)
		return
	
	
	code = code.replace("()", "")
	
	
	turn += 1
	robot.call(code)
	print("next tile: ", robot.next_tile)
	print("robot_dir: ", robot.robot_direction)
	waiting = true


func code_validator(code: String, code_split: Array[String]) -> Array:
	if code_split.is_empty():
		return[true, no_code_error]
	
	if code_split[0] == "for":
		if for_looping:
			#print("starting a for loop inside a for loop. What to do if nested loop?")
			return [false, nested_loop_error]
		
		
		return for_loop_validator(code_split)
	return base_func_validator(code)


func base_func_validator(code: String) -> Array:
	if not code in base_functions:
		return [false, unknown_func_error + code]
	return [true, code]


func for_loop_validator(code_split: Array[String]) -> Array:
	print("For loop start!")
	print(code_split)
	if not len(code_split) == 4:
		return [false, syntax_error]
	
	
	if code_split[1] in variables.keys():
		return [false, for_loop_var_exists_error_1 + str(code_split[1]) + for_loop_var_exists_error_2]
	
	
	if not code_split[2] == "in":
		return [false, for_loop_in_error]
	
	
	if code_split[3].begins_with("range(") and code_split[3].ends_with("):"):
	#if code_split[3].begins_with("range("):
		var range_split = code_split[3].split("(", false) #should have range_split[0] = "range", range_split[1] = "n):"
		var after_range_split = range_split[1].split(")", false) # should have after_range_split[0] = "n", after_range_split[1] = ":"
		
		
		if not after_range_split[0].is_valid_int():
			return [false, inside_range_error]
			
			
	else:
		get_node("/root/Node2D/code/GoButton").disabled = true
		return [false, range_error]
	return [true, "success"]


func _on_go_button_pressed() -> void:
	start_code()
	

func init_code_lines() -> void:
	codeLines.clear()
	var for_loop_content = []
	var previous_line = "previous line"
	var previous_ind = false
	
	for i in range(text_edit.get_line_count()):
		var ind = text_edit.get_indent_level(i)
		var line = text_edit.get_line(i)
		
		
		if line.is_empty():
			continue
		
		
		if ind == 0:
			previous_ind = false
			if len(for_loop_content) > 0:
				codeLines.append(for_loop_content.duplicate())
				for_loop_content.clear()
			
			
			codeLines.append(line)
			
		else:
			previous_ind = true
			if previous_line.split(" ", false)[0] == "for":
				for_loop_content.append(line)
			elif previous_ind == true:
				for_loop_content.append(line)
			else:
				line = line.strip_edges()
				if len(for_loop_content) > 0:
					codeLines.append(for_loop_content.duplicate())
					for_loop_content.clear()
				
				codeLines.append(line)
		
		previous_line = line

	
	
	if len(for_loop_content) > 0:
		codeLines.append(for_loop_content)
	print("code lines: ", codeLines)


func start_code() -> void:
	go_button.hide()
	stop_button.show()
	init_code_lines()
	running_code = true
	
	
	if get_node("/root/Node2D").has_node("lasers"):
		for laser in get_node("/root/Node2D/lasers").get_children():
			laser.start()


func robot_changes_wait(temp_robot: Robot, new_wait: bool) -> void:
	#is this a good way to do it?
	robot = temp_robot
	waiting = new_wait


func set_waiting(value: bool) -> void:
	waiting = value


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
	if for_loop_valid[0] == true:
		get_node("/root/Node2D/code/GoButton").disabled = false
	
	
	if for_loop_valid[0] or old_line.begins_with("\t"):
		text_edit.set_line(to_line, "\t")
		
		
		#set line only updates the text internally, so we need to wait until after the frame is done to update the caret
		await get_tree().process_frame
		text_edit.set_caret_column(len(text_edit.get_line(to_line)))


func _on_timer_timeout() -> void:
	var errors_text = []
	
	for i in range(text_edit.get_line_count()):
		var line = text_edit.get_line(i)
		
		
		line = line.strip_edges()
		var line_split = line.split(" ", false)
		
		
		var validation_array = code_validator(line, line_split)
		var validation = validation_array[0]
		var error_message = validation_array[1]
		
		if validation:
			text_edit.set_line_background_color(i, Color(0, 0, 0, 0))
			continue
		
		text_edit.set_line_background_color(i, Color(255,0,0))
		errors_text.append(error_message)
		print("Error: ", error_message)
	
	
	if errors_text.is_empty():
		error_node.text = ""
		if text_edit.get_line_count() == line_limit:
			error_node.text = last_line_error
		return
	
	
	var full_error = ""
	for error in errors_text:
		if not full_error.is_empty():
			full_error += "\n"
		full_error += error
	
	
	error_node.text = full_error


func _on_stop_button_pressed() -> void:
	#stop_running_code()
	Global.restart_level()
