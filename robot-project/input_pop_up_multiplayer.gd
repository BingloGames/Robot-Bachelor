extends "res://input_pop_up.gd"


var player_correct_answer = []
var players_answered = []


func show_input() -> void:
	super.show_input()
	
	
	for robot in code_node.robot_waiting_data:
		code_node.robot_waiting_data[robot]["running_code"] = false


func correct_answer() -> void:
	robot_answer_correct.rpc()


@rpc("any_peer", "call_local")
func robot_answer_correct() -> void:
	var player_id = multiplayer.get_remote_sender_id()
	if player_id in players_answered:
		return
	
	
	players_answered.append(player_id)
	player_correct_answer.append(player_id)
	
	
	if len(player_correct_answer) == ConnectionController.NUM_PLAYERS:
		print("correct answer from both multiplayer")
		success_question()
		
		
		
	elif len(players_answered) == ConnectionController.NUM_PLAYERS:
		if len(players_answered) == ConnectionController.NUM_PLAYERS:
			failed_question()


func success_question() -> void:
	super.correct_answer()
	
	
	player_correct_answer.clear()
	players_answered.clear()


func wrong_answer() -> void:
	print("wrong answer")
	robot_answer_wrong.rpc()


@rpc("any_peer", "call_local")
func robot_answer_wrong() -> void:
	var player_id = multiplayer.get_remote_sender_id()
	if player_id in players_answered:
		return
	
	
	players_answered.append(player_id)
	
	
	if len(players_answered) == ConnectionController.NUM_PLAYERS:
		failed_question()


func failed_question() -> void:
	super.wrong_answer()
	
	
	for robot in code_node.robot_waiting_data:
		code_node.robot_waiting_data[robot]["running_code"] = true
	
	
	player_correct_answer.clear()
	players_answered.clear()
