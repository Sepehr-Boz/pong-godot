extends Node

signal on_ball_spawned(ball: Ball)
signal on_mode_set(mode: GameMode)
enum GameMode { TWO_PLAYER, FOUR_PLAYER }

var _game_mode: GameMode = GameMode.TWO_PLAYER

var _two_player_scene: PackedScene = preload("res://scenes/two_player.tscn")
var _four_player_scene: PackedScene = preload("res://scenes/four_player.tscn")
var _ball_scene: PackedScene = preload("res://scenes/ball.tscn")

var _current_game_scene: Node
static var current_ball: Ball

func _ready() -> void:
	# to allow other listeners (game ui) to connect to game manager, then wait a bit
	# before starting the game
	await get_tree().create_timer(0.1).timeout
	reset_game()

func set_game_mode(mode: GameMode) -> void:
	# dont do anything if setting to the current mode
	if mode == _game_mode:
		return
	_game_mode = mode
	_current_game_scene.free()
	current_ball.free()
	_current_game_scene = _two_player_scene.instantiate() if mode == GameMode.TWO_PLAYER else _four_player_scene.instantiate()
	add_child(_current_game_scene)
	current_ball = _ball_scene.instantiate()
	add_child(current_ball)
	var cam: Camera2D = get_viewport().get_camera_2d()
	var vp: Rect2 = get_viewport().get_visible_rect()
	current_ball.position = (vp.position + vp.size / cam.zoom / 2) + cam.offset
	on_ball_spawned.emit(current_ball)
	on_mode_set.emit(mode)
	

func reset_game() -> void:
	if _current_game_scene != null:
		_current_game_scene.free()
	if current_ball != null:
		current_ball.free()
	_current_game_scene = _two_player_scene.instantiate() if _game_mode == GameMode.TWO_PLAYER else _four_player_scene.instantiate()
	add_child(_current_game_scene)
	current_ball = _ball_scene.instantiate()
	add_child(current_ball)
	var cam: Camera2D = get_viewport().get_camera_2d()
	var vp: Rect2 = get_viewport().get_visible_rect()
	current_ball.position = (vp.position + vp.size / cam.zoom / 2) + cam.offset
	on_ball_spawned.emit(current_ball)
	on_mode_set.emit(_game_mode)
