extends "res://input_pop_up.gd"


var player_correct_answer = []
var players_answered = []


func show_input() -> void:
	super.show_input()
	
	
	for robot in get_node("/root/Node2D/code").robot_waiting_data:
		get_node("/root/Node2D/code").robot_waiting_data[robot]["running_code"] = false


func correct_answer():
	robot_answer_correct.rpc()


@rpc("any_peer", "call_local")
func robot_answer_correct():
	var player_id = multiplayer.get_remote_sender_id()
	if player_id in players_answered:
		return
	
	
	players_answered.append(player_id)
	player_correct_answer.append(player_id)
	
	
	if len(player_correct_answer) == 2:
		print("correct answer from both multiplayer")
		success_question()
		
		
		
	elif len(players_answered) == 2:
		if len(players_answered) == 2:
			failed_question()


func success_question():
	super.correct_answer()
	
	
	player_correct_answer.clear()
	players_answered.clear()


func wrong_answer():
	print("wrong answer")
	robot_answer_wrong.rpc()


@rpc("any_peer", "call_local")
func robot_answer_wrong():
	var player_id = multiplayer.get_remote_sender_id()
	if player_id in players_answered:
		return
	
	
	players_answered.append(player_id)
	
	
	if len(players_answered) == 2:
		failed_question()


func failed_question():
	super.wrong_answer()
	
	
	for robot in get_node("/root/Node2D/code").robot_waiting_data:
		get_node("/root/Node2D/code").robot_waiting_data[robot]["running_code"] = true
	
	
	player_correct_answer.clear()
	players_answered.clear()
