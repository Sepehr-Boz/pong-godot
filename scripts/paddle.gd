class_name Paddle
extends Area2D

enum ControlMode { AI, PLAYER }

@export var _move_speed: float = 1.0
@export var _up_key: Key
@export var _down_key: Key
@export var _control_mode: ControlMode

var _move: float
@onready var _ball: Ball = $"../Ball"
@onready var _shape: Shape2D = $"CollisionShape2D".shape
@onready var _min_y: float = _shape.size.y / 2
@onready var _max_y: float = (get_viewport().get_visible_rect().size.y / get_viewport().get_camera_2d().zoom.y) - (_shape.size.y / 2)

# for process/frame checking for inputs as since there are 1+ paddles in the
# game at once then multiple _input receivers will clash and affect each
# other so it is better to check for key press/release every frame
# MANUAL
func _handle_input() -> void:
	if Input.is_key_pressed(_up_key):
		_move = -_move_speed
	elif Input.is_key_pressed(_down_key):
		_move = _move_speed
	else:
		_move = 0

# AI
func _determine_movement() -> void:
	# only move up/down when the ball is coming towards it
	if (position.x < _ball.position.x and _ball._move_direction.x < 0) or (position.x > _ball.position.x and _ball._move_direction.x > 0):
		# find the distance to the center
		var dist_to_center: float = abs(_ball.position.y - position.y)
		if _ball.position.y > position.y:
			_move = _move_speed
		elif _ball.position.y < position.y:
			_move = -_move_speed
		else:
			_move = 0
		_move *= clamp(dist_to_center / _min_y, 0, 1)
	else:
		_move = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _control_mode == ControlMode.PLAYER:
		_handle_input()
	else:
		_determine_movement()
	position += Vector2(0, _move * delta)
	position.y = clampf(position.y, _min_y, _max_y)
