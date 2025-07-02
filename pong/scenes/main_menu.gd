extends Control





func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/pong.tscn") # Replace with function body.


func _on_exit_pressed() -> void:
		get_tree().quit()
