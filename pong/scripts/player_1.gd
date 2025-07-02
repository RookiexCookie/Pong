extends Node2D


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("player_1_up"):
		position.y-= 1
	if Input.is_action_just_pressed("player_1_down"):
		position.y+=1
