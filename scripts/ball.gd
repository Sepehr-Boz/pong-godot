class_name Ball
extends Area2D

signal on_paddle_hit(paddle_num: int)
signal on_score(winner_num: int)

@export var _initial_move_speed: float = 1.0
@export var _move_speed_increment: float = 0.1
@export var _max_bounce_deviation: float = 0.005

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _move_direction: Vector2
var _current_move_speed: float
var _last_hit_by_player: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_move_direction = Vector2(
		_rng.randf_range(0.5, 1) * (-1 if _rng.randi_range(0, 1) == 0 else 1),
		_rng.randf_range(0.5, 1) * (-1 if _rng.randi_range(0, 1) == 0 else 1)).normalized()
	_last_hit_by_player = 0
	_current_move_speed = _initial_move_speed
	area_entered.connect(_on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_check_edge_collision()
	position += _move_direction * _current_move_speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Paddle"):
		area = area as Paddle
		_move_direction = (
			_move_direction.bounce(area.normal_vector)
			+ Vector2(
				_rng.randf_range(-_max_bounce_deviation, _max_bounce_deviation),
				_rng.randf_range(-_max_bounce_deviation, _max_bounce_deviation))
			).normalized()
		_current_move_speed += _move_speed_increment
		_last_hit_by_player = area.player_num
		on_paddle_hit.emit(_last_hit_by_player)

func _check_edge_collision() -> void:
	# check if out of bounds based on the extents defined in the game manager singleton
	# if in 2-player mode then only check for left-right out of bounds for scoring
	# if in 4-player mode then check all sides for out of bounds and never bounce off walls
	if GameManager._game_mode == GameManager.GameMode.TWO_PLAYER:
		if position.x <= -GameManager.extents.x or position.x >= GameManager.extents.x:
			on_score.emit(_last_hit_by_player)
			position = Vector2.ZERO
			_move_direction = Vector2(_rng.randf_range(-1.0, 1.0), _rng.randf_range(-1.0, 1.0))
			_current_move_speed = _initial_move_speed
			_last_hit_by_player = 0
		elif position.y - 0.5 <= -GameManager.extents.y:
			position.y = -GameManager.extents.y + 0.5
			_move_direction.y = -_move_direction.y
		elif position.y + 0.5 >= GameManager.extents.y:
			position.y = GameManager.extents.y - 0.5
			_move_direction.y = -_move_direction.y
	else:
		if not Rect2(-GameManager.extents, GameManager.extents * 2).has_point(position):
			on_score.emit(_last_hit_by_player)
			position = Vector2.ZERO
			_move_direction = Vector2(_rng.randf_range(-1.0, 1.0), _rng.randf_range(-1.0, 1.0))
			_current_move_speed = _initial_move_speed
			_last_hit_by_player = 0
