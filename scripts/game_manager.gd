extends Node

enum GameMode { TWO_PLAYER, FOUR_PLAYER }

var _game_mode: GameMode = GameMode.TWO_PLAYER

var _two_player_scene: PackedScene = preload("res://scenes/two_player.tscn")
var _four_player_scene: PackedScene = preload("res://scenes/four_player.tscn")

var _current_game_scene: Node

func _ready() -> void:
	# spawn in the default game scene: 2-player
	_current_game_scene = _two_player_scene.instantiate()
	add_child(_current_game_scene)

func set_game_mode(mode: GameMode) -> void:
	# dont do anything if setting to the current mode
	if mode == _game_mode:
		return
	_game_mode = mode
	_current_game_scene.free()
	_current_game_scene = _two_player_scene.instantiate() if mode == GameMode.TWO_PLAYER else _four_player_scene.instantiate()
	add_child(_current_game_scene)


func reset_game() -> void:
	_current_game_scene.free()
	_current_game_scene = _two_player_scene.instantiate() if _game_mode == GameMode.TWO_PLAYER else _four_player_scene.instantiate()
	add_child(_current_game_scene)
