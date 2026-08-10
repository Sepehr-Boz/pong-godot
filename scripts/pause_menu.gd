class_name PauseMenu
extends CanvasLayer

enum GameMode { NORMAL, AI_PLAYGROUND, FOUR_PLAYER }

@onready var _continue_button: Button = $"VBoxContainer/Continue Button"
@onready var _reset_button: Button = $"VBoxContainer/Reset Button"
@onready var _quit_button: Button = $"VBoxContainer/Quit Button"
@onready var _mode_dropdown: OptionButton = $"VBoxContainer/Game Mode Dropdown"

var _game_mode: GameMode = GameMode.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	_continue_button.pressed.connect(_on_esc_press)
	_reset_button.pressed.connect(_on_reset_press)
	_quit_button.pressed.connect(_on_quit_press)
	_mode_dropdown.item_selected.connect(_on_mode_selected)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		event = event as InputEventKey
		if event.is_action_pressed("ui_cancel"):
			_on_esc_press()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_esc_press() -> void:
	if visible:
		Engine.time_scale = 1
		visible = false
	else:
		Engine.time_scale = 0
		visible = true

func _on_reset_press() -> void:
	pass # TODO: reset the game arena based on the current mode

func _on_quit_press() -> void:
	get_tree().quit()

func _on_mode_selected(mode: GameMode) -> void:
	_game_mode = mode
