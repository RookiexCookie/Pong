extends Node2D
@onready var player_2: Node2D = $player_2
@onready var ball: CharacterBody2D = $ball
@onready var player_1: Node2D = $player_1
@onready var player_1_score: RichTextLabel = $player_1_score
@onready var player_2_score: RichTextLabel = $player_2_score

# Game variables
var player1_score := 0
var player2_score := 0
var base_ball_speed := 350
var current_ball_speed := base_ball_speed
var ball_direction := Vector2.ZERO
var screen_size := Vector2(1280, 720)
var paddle_height := 100
var half_paddle_height := paddle_height / 2
var ball_radius := 8
var speed_increase_rate := 1.1
var max_ball_speed := 800

func _ready() -> void:
	screen_size = get_viewport_rect().size
	update_score_display()
	start_ball()

func _process(delta: float) -> void:
	# Player movement with boundaries
	if Input.is_action_pressed("player_1_down"):
		player_1.position.y = min(player_1.position.y + 15, screen_size.y - half_paddle_height)
	if Input.is_action_pressed("player_1_up"):
		player_1.position.y = max(player_1.position.y - 15, half_paddle_height)
	if Input.is_action_pressed("player_2_down"):
		player_2.position.y = min(player_2.position.y + 15, screen_size.y - half_paddle_height)
	if Input.is_action_pressed("player_2_up"):
		player_2.position.y = max(player_2.position.y - 15, half_paddle_height)

func _physics_process(delta: float) -> void:
	# Ball movement with precise boundary checks
	var new_position = ball.position + (ball_direction * current_ball_speed * delta)
	
	# Top/bottom boundary checks
	if new_position.y <= ball_radius:
		new_position.y = ball_radius
		ball_direction.y *= -1
	elif new_position.y >= screen_size.y - ball_radius:
		new_position.y = screen_size.y - ball_radius
		ball_direction.y *= -1
	
	ball.position = new_position
	
	# Handle collisions with paddles
	var collision = ball.move_and_collide(ball_direction * current_ball_speed * delta)
	if collision:
		ball_direction = ball_direction.bounce(collision.get_normal())
		ball_direction.y += randf_range(-0.2, 0.2)
		ball_direction = ball_direction.normalized()
		
		# Increase speed after each paddle hit (with cap)
		current_ball_speed = min(current_ball_speed * speed_increase_rate, max_ball_speed)

	# Scoring
	if ball.position.x < -50:
		player2_score += 1
		score_for_player(2)
	elif ball.position.x > screen_size.x + 50:
		player1_score += 1
		score_for_player(1)

func start_ball():
	var start_x = [-1, 1].pick_random()
	ball_direction = Vector2(start_x, randf_range(-0.5, 0.5)).normalized()
	ball.position = screen_size / 2
	current_ball_speed = base_ball_speed
	# Reset paddle positions to center
	player_1.position.y = screen_size.y / 2
	player_2.position.y = screen_size.y / 2

func score_for_player(player: int):
	update_score_display()
	print("Player 1: %d | Player 2: %d" % [player1_score, player2_score])
	start_ball()

func update_score_display():
	player_1_score.text = str(player1_score)
	player_2_score.text = str(player2_score)
