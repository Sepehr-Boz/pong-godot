class_name GameUI
extends CanvasLayer

@onready var _player1_label: RichTextLabel = $HSplitContainer/RichTextLabel
@onready var _player2_label: RichTextLabel = $HSplitContainer/RichTextLabel2

var _player1_score: int
var _player2_score: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player1_score = 0
	_player2_score = 0
	_update_labels()

func player_scored(player_num: int) -> void:
	if player_num == 1:
		_player1_score += 1
	elif player_num == 2:
		_player2_score += 1
	_update_labels()

func _update_labels() -> void:
	_player1_label.text = "[font_size=32]Player 1 : %d[/font_size]" % _player1_score
	_player2_label.text = "[font_size=32]Player 2 : %d[/font_size]" % _player2_score
