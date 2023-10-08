extends Control
signal RTP(node)
func _on_multiple_player_pressed():
	pass # Replace with function body.

func _on_rtp_pressed():
	RTP.emit(self)


func _on_quit_pressed():
	get_tree().quit()
