class_name Paddle
extends Area2D

@export var _move_speed: float = 1.0
@export var _up_key: Key
@export var _down_key: Key

var _move: float

# for process/frame checking for inputs as since there are 1+ paddles in the
# game at once then multiple _input receivers will clash and affect each
# other so it is better to check for key press/release every frame
func _handle_input() -> void:
	if Input.is_key_pressed(_up_key):
		_move = -_move_speed
	elif Input.is_key_pressed(_down_key):
		_move = _move_speed
	else:
		_move = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_input()
	position += Vector2(0, _move * delta)
