extends Control
class_name CodeWindow
##Code window for the player to introduce the Robots commands.

##The CodeEdit child of this node.
@onready var text_edit = get_node("CodeEdit")
##The particles child of this node.
@onready var go_button = get_node("GoButton")
##The particles child of this node.
@onready var stop_button = get_node("StopButton")
##The particles child of this node.
@onready var error_node = get_node("error message")


#update with language. Errors in default english.
const last_line_error = "Warning: Last line"
const code_stopped_text = "Code stopped"
const line_problem_text = "Problem at line: "
const no_code_error = "No code"
const nested_loop_error = "Nested loop"
const unknown_func_error = "Unknown function: "
const syntax_error = "Syntax error"
const for_loop_var_exists_error_1 = "Variable: "
const for_loop_var_exists_error_2 = " in for loop already exist"
const for_loop_in_error = "Syntax error (no 'in' or 'in' at wrong place)"
const inside_range_error = "Syntax error! (error inside range())"
const range_error = "Invalid syntax with range!"
const for_loop_content_invalid = "For loop content invalid"

##list of the Robot's base functions.
var base_functions = ["forward()", "backward()", "left()", "right()", "wait()"]

##Variable that stores the players commands for the robot.
var codeLines = []
##Limit of lines for each level.
@export var line_limit: int = 5

##Variable that represents the robot.
var robot = null
##Indicates if the robot is waiting or not.
var waiting = false: set = set_waiting
##Current robot turn. Used to indicate in which specific line the robot dies.
@onready var turn = 0

##Indicates if the code is currently running.
var running_code = false

##Indicates if the robot is inside a loop.
var for_looping = false
##How many times has the loop been running.
var for_loop_count = 0
##Which line inside the loop is the robot currently in.
var for_loop_line = 0
##Contents of the for loop.
var for_loop_contents = []
##Number of times the loop has to run.
var for_loop_max = 0

##Variable names and their values. Not used.
var variables = {} #variable_name : variable_value
##For loop variable names and their values. Not used.
var for_loop_variables = {} 


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
		robot.check_end()
		running_code = false
		return
	
	run_code()

##Runs the first command and deletes it from the list.
func run_code() -> void:
	if for_looping:
		if len(for_loop_contents) == 0:
			Global.restart_level()
		else:
			continue_for_loop()
		
		#still for looping?
		if for_looping:
			return
		if len(codeLines) == 0:
			return
	
	var code = codeLines.pop_front()
	run_line(code)

##If there is an error, or the robot dies, turns the problematic line, or the line where the robot died
## to red, and shows the error and line number in the error message for the player to see.
func problem_warning() -> void:
	if turn == 0:
		error_node.set_text(code_stopped_text)
	else:
		error_node.set_text(line_problem_text+str(turn))
		text_edit.set_line_background_color(turn-1, Color(255,0,0))

##Stops the player's commands from running.
func stop_running_code() -> void:
	turn = 0
	go_button.show()
	stop_button.hide()
	waiting = false
	running_code = false
	codeLines.clear()
	
	go_button.set_disabled(true)
	
	for_looping = false
	for_loop_count = 0
	for_loop_line = 0
	for_loop_contents.clear()
	for_loop_max = 0
	
	variables.clear()
	for_loop_variables.clear()

##Runs the given command.
func run_line(code: String) -> void:
	var code_split = code.split(" ", false)
	
	if len(code_split) == 0:#code is empty
		turn += 1
		return
	
	if code_split[0] == "for":
		if for_looping:
			return
		
		start_for_loop(code_split)
		return
	
	run_base_functions(code)

##Starts a loop. 
func start_for_loop(code_split: Array[String]) -> void:
	#for loop already validated, so we know this works
	turn += 1
	var range_split = code_split[3].split("(", false) #should have range_split[0] = "range", range_split[1] = "n):"
	var after_range_split = range_split[1].split(")", false) # should have after_range_split[0] = "n", after_range_split[1] = ":"
	for_loop_max = after_range_split[0].to_int()
	
	for_loop_variables[code_split[1]] = 0 #usually i = 0
	for_looping = true
	
	for_loop_contents = codeLines.pop_front()
	
	if len(for_loop_contents) == 0:
		Global.restart_level()
	
	else:
		continue_for_loop()

##Continues the loop as many times as needed.
func continue_for_loop() -> void:
	if for_loop_line >= len(for_loop_contents):
		for_loop_line = 0
		for_loop_count += 1
		
		if for_loop_count >= for_loop_max: #verify if correct
			#remove the codeLines in the for loop that just ended
			
			#reset for loop variables
			for_looping = false
			for_loop_count = 0
			for_loop_contents.clear()
			for_loop_max = 0
			for_loop_variables.clear()
			return
		else:
			turn -= len(for_loop_contents)
	
	var code_line = for_loop_contents[for_loop_line].strip_edges()
	run_line(code_line)
	for_loop_line += 1

##If the Command is one of the base functions, sends it to the robot node for it to run.
func run_base_functions(code: String) -> void:
	turn += 1
	if not code in base_functions:
		return
	
	code = code.replace("()", "")
	
	robot.call(code)
	print("next tile: ", robot.next_tile)
	print("robot_dir: ", robot.robot_direction)
	waiting = true

##Checks for misspellings in the code window.
func code_validator(code: String, code_split: Array[String], next_code: String) -> Array:
	if code_split.is_empty():
		return[true, no_code_error]
	
	if code_split[0] == "for":
		if for_looping:
			return [false, nested_loop_error]
		
		return for_loop_validator(code_split, next_code)
	return base_func_validator(code)

##Checks if the command is one of the basic functions, if not, gives an error.
func base_func_validator(code: String) -> Array:
	if not code in base_functions:
		return [false, unknown_func_error + code]
	return [true, code]

##Checks if the command is a for loop, if it has a proper number for the range, if its properly written, and if it has contents.
##  If not, it gives the apropiate error for each case.
func for_loop_validator(code_split: Array[String], next_code: String) -> Array:
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
		return [false, range_error]
	
	if not next_code.begins_with("\t"):
		return [false, for_loop_content_invalid]
	
	next_code = next_code.strip_edges()
	var next_line_validation = base_func_validator(next_code)
	
	#next line not valid
	if not next_line_validation[0]:
		return [false, for_loop_content_invalid]
	
	return [true, "success"]

func _on_go_button_pressed() -> void:
	start_code()

##Takes the commands from the code window and puts them in a list.
func init_code_lines() -> void:
	codeLines.clear()
	var for_loop_content = []
	var previous_line = "previous line"
	var previous_ind = false
	
	for i in range(text_edit.get_line_count()):
		var ind = text_edit.get_indent_level(i)
		var line = text_edit.get_line(i)
		
		if line.strip_edges().is_empty():
			if i == text_edit.get_line_count()-1:#last line
				continue
			if previous_line.split(" ", false)[0] == "for":#just started a for loop
				for_loop_content.append("")
			elif previous_ind:#continues a for loop
				for_loop_content.append("")
			else:#not in a for loop
				codeLines.append("")
			continue
		
		if ind == 0:
			previous_ind = false
			if len(for_loop_content) > 0:
				codeLines.append(for_loop_content.duplicate())
				for_loop_content.clear()
			
			codeLines.append(line)
		
		else:
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
			previous_ind = true
		
		previous_line = line
		
	if len(for_loop_content) > 0:
		codeLines.append(for_loop_content)

##Starts the code.
func start_code() -> void:
	go_button.hide()
	stop_button.show()
	init_code_lines()
	running_code = true
	
	if get_node("/root/Node2D").has_node("lasers"):
		for laser in get_node("/root/Node2D/lasers").get_children():
			laser.start()

##Puts robot in waiting mode.
func robot_changes_wait(temp_robot: Robot, new_wait: bool) -> void:
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
	
	go_button.disabled = true
	get_node("Timer").start()
	
	if not from_line+1 == to_line:
		return
	
	var old_line = text_edit.get_line(from_line)
	var old_line_split = old_line.split(" ")
	#does not care if next line in for loop is invalid
	var for_loop_valid_data = for_loop_validator(old_line_split, "")
	var for_loop_valid = for_loop_valid_data[0]
	var for_loop_valid_error = for_loop_valid_data[1]
	
	#if line is for loop valid, if line is indented or if for loop invalid because content is empty
	if for_loop_valid or old_line.begins_with("\t") or (not for_loop_valid and for_loop_valid_error == for_loop_content_invalid):
		text_edit.set_line(to_line, "\t")
		
		#set line only updates the text internally, so we need to wait until after the frame is done to update the caret
		await get_tree().process_frame
		text_edit.set_caret_column(len(text_edit.get_line(to_line)))

func _on_timer_timeout() -> void:
	var errors_text = []
	
	for i in range(text_edit.get_line_count()):
		var line = text_edit.get_line(i)
		var next_line = text_edit.get_line(i+1)
		
		line = line.strip_edges()
		var line_split = line.split(" ", false)
		
		var validation_array = code_validator(line, line_split, next_line)
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
		go_button.disabled = false
		if text_edit.get_line_count() == line_limit:
			error_node.text = last_line_error
		return
	
	go_button.disabled = true
	
	var full_error = ""
	for error in errors_text:
		if not full_error.is_empty():
			full_error += "\n"
		full_error += error
	
	error_node.text = full_error

func _on_stop_button_pressed() -> void:
	#stop_running_code()
	Global.restart_level()
