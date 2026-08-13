extends CanvasLayer

@onready var _score_container: Container = $HSplitContainer
var _player_labels: Dictionary[int, RichTextLabel] = {}
var _player_scores: Dictionary[int, int] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	GameManager.on_ball_spawned.connect(_listen_to_ball)
	GameManager.on_mode_set.connect(_reset_ui)
	_reset_ui(GameManager.GameMode.TWO_PLAYER)

func _listen_to_ball(ball: Ball) -> void:
	ball.on_score.connect(_player_scored)

func _remove_labels() -> void:
	for key in _player_labels.keys():
		_player_labels[key].free()
	_player_labels.clear()
	_player_scores.clear()

func _reset_ui(mode: GameManager.GameMode) -> void:
	_remove_labels()
	for i in range(1, 3 if mode == GameManager.GameMode.TWO_PLAYER else 5):
		var label: RichTextLabel = RichTextLabel.new()
		label.bbcode_enabled = true
		label.scroll_active = false
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.size_flags_vertical = Control.SIZE_EXPAND_FILL
		_score_container.add_child(label)
		_player_labels[i] = label
		_player_scores[i] = 0
	_update_labels()

func _player_scored(player_num: int) -> void:
	_player_scores[player_num] += 1
	_update_labels()

func _update_labels() -> void:
	for key in _player_labels.keys():
		_player_labels[key].text = "[font_size=32]Player %d : %d[/font_size]" % [key, _player_scores[key]]
