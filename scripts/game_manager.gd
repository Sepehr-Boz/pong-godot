extends Node

enum GameMode { NORMAL, AI_PLAYGROUND, FOUR_PLAYER }

var _game_mode: GameMode = GameMode.NORMAL

func set_game_mode(mode: GameMode) -> void:
	# dont do anything if setting to the current mode
	if mode == _game_mode:
		return
	_game_mode = mode
	# TODO: refresh the game scene with the correct number of paddles, control
	# TODO: modes set, etc.

func reset_game() -> void:
	pass
	# TODO: refresh the current game scene
