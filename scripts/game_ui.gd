class_name GameUI
extends CanvasLayer

@onready var _player1_label: RichTextLabel = $"HSplitContainer/Player 1 Score"
@onready var _player2_label: RichTextLabel = $"HSplitContainer/Player 2 Score"
@onready var _ball_speed_label: RichTextLabel = $"HSplitContainer/Ball Speed"
@onready var _ball: Ball = $"../Ball"

var _player1_score: int
var _player2_score: int
var _ball_speed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player1_score = 0
	_player2_score = 0
	_ball_speed = _ball._initial_move_speed
	_update_labels()

func player_scored(player_num: int) -> void:
	if player_num == 1:
		_player1_score += 1
	elif player_num == 2:
		_player2_score += 1
	_update_labels()

func ball_speed_increased_to(new_speed: float) -> void:
	_ball_speed = new_speed
	_update_labels()

func _update_labels() -> void:
	_player1_label.text = "[font_size=32]Player 1 : %d[/font_size]" % _player1_score
	_player2_label.text = "[font_size=32]Player 2 : %d[/font_size]" % _player2_score
	_ball_speed_label.text = "[font_size=22]Speed : %.1f[/font_size]" % _ball_speed
