class_name Ball
extends Area2D

const BALL_RADIUS: float = 1.0

@export var _initial_move_speed: float = 1.0
@export var _move_speed_increment: float = 0.1

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _move_direction: Vector2
var _current_move_speed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_move_direction = Vector2(_rng.randf_range(-1.0, 1.0), _rng.randf_range(-1.0, 1.0))
	_current_move_speed = _initial_move_speed
	area_entered.connect(_on_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_check_edge_collision()
	position += _move_direction * _current_move_speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Paddle"):
		_move_direction.x = -_move_direction.x
		_current_move_speed += _move_speed_increment

func _check_edge_collision() -> void:
	var vp: Viewport = get_viewport()
	var vp_size: Vector2 = vp.get_visible_rect().size / vp.get_camera_2d().zoom
	var pos: Vector2 = position
	print(pos, vp_size)
	if pos.x <= 0.5 or pos.x + 0.5 >= vp_size.x:
		pass # TODO: score a point for player 1/2
	elif pos.y <= 0.5:
		position.y = 0.5
		_move_direction.y = -_move_direction.y
	elif pos.y + 0.5 >= vp_size.y:
		position.y = vp_size.y - 0.5
		_move_direction.y = -_move_direction.y

func _draw() -> void:
	draw_circle(Vector2.ZERO, BALL_RADIUS, Color("0000ff"))
