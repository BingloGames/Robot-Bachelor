extends "res://input_pop_up.gd"


var player_correct_answer = []



func correct_answer():
	robot_answer_correct.rpc()


@rpc("any_peer", "call_local")
func robot_answer_correct():
	
	var player_id = multiplayer.get_remote_sender_id()
	if player_id in player_correct_answer:
		return
	player_correct_answer.append(player_id)
	
	
	if len(player_correct_answer) == 2:
		print("correct answer from both multiplayer")
		super.correct_answer()
		
		
		#for temp_robot in get_node("/root/Node2D/code").robot_waiting_data.keys():
			#get_node("/root/Node2D/code").robot_waiting_data[temp_robot]["running_code"] = true
