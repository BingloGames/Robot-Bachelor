extends TextEdit
var codeLines = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	# In _physics_process or _process


func _on_button_pressed():
	codeLines = []
	var x = 0
	for i in range (get_line_count()):
		var ind = get_indent_level(i)
		if ind == 0:
			var line = get_line(i)
			codeLines[x] = line
			x += 1
		else:
			var y = x-1
			var prevLine = codeLines[y]
			var line = get_line(i)
			var lines = prevLine + line
			codeLines[y] = lines
	print(codeLines)
