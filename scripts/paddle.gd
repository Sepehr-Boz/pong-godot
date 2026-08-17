class_name Paddle
extends Area2D

enum ControlMode { AI, PLAYER }

@export var _move_speed: float = 1.0
@export var _up_key: Key
@export var _down_key: Key
@export var _up_direction: Vector2 = Vector2.UP
@export var _down_direction: Vector2 = Vector2.DOWN
@export var _control_mode: ControlMode

var _move: float
var _is_moving_up: bool
@onready var _shape: Shape2D = $"CollisionShape2D".shape
@onready var _max_y: float = (get_canvas_transform().affine_inverse() * get_viewport_rect()).end.y - (_shape.size.y / 2)
@onready var _min_y: float = -_max_y

func _ready() -> void:
	_is_moving_up = false

# for process/frame checking for inputs as since there are 1+ paddles in the
# game at once then multiple _input receivers will clash and affect each
# other so it is better to check for key press/release every frame
# MANUAL
func _handle_input() -> void:
	if Input.is_key_pressed(_up_key):
		_is_moving_up = true
		_move = _move_speed
	elif Input.is_key_pressed(_down_key):
		_is_moving_up = false
		_move = _move_speed
	else:
		_move = 0

# AI
func _determine_movement() -> void:
	# check if moving towards the paddle based on the balls movement direction and the wall
	# the paddle is on
	var ball_pos: Vector2 = GameManager.current_ball.position
	var ball_move_dir: Vector2 = GameManager.current_ball._move_direction.normalized()
	var intersect = Geometry2D.segment_intersects_segment(ball_pos, ball_pos + ball_move_dir * 100, position + _up_direction * 100, position + _down_direction * 100)
	if intersect != null:
		# find where the ball will intersect with the 'line' that the paddle moves along and move towards it
		# if close enough to the intersect then dont move, otherwise find out if need to move 'up'
		# or 'down' then move that direction
		var dist_to_intersect: float = position.distance_to(intersect)
		if dist_to_intersect <= 4:
			_move = 0
		elif position.distance_to(intersect - _up_direction) < position.distance_to(intersect - _down_direction):
			_move = _move_speed
			_is_moving_up = true
		else:
			_move = _move_speed
			_is_moving_up = false
	else:
		_move = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _control_mode == ControlMode.PLAYER:
		_handle_input()
	else:
		_determine_movement()
	if _is_moving_up:
		position += _up_direction * _move * delta
	else:
		position += _down_direction * _move * delta
	position.y = clampf(position.y, _min_y, _max_y)
