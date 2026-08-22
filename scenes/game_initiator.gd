extends Node2D

@export var _start_key: Key = Key.KEY_SPACE
@export var _reset_key: Key = Key.KEY_R
@export var _paddles: Array[Paddle] = []
@onready var _main_label: RichTextLabel = $"Main Label"

func _ready() -> void:
	for paddle: Paddle in _paddles:
		# find the ui node in the child and set it active
		for child: Node in paddle.get_children():
			if child is RichTextLabel:
				child.visible = true
				break
	_main_label.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _main_label.visible:
		return
	# when the start key is pressed then begin the game otherwise keep listening for
	# key presses of the paddles to enable PLAYER mode on them
	if Input.is_key_pressed(_start_key):
		GameManager.spawn_ball()
		for paddle: Paddle in _paddles:
			# find the ui node in the child and set it inactive
			for child: Node in paddle.get_children():
				if child is RichTextLabel:
					child.visible = false
					break
		_main_label.visible = false
	elif Input.is_key_pressed(_reset_key):
		for paddle: Paddle in _paddles:
			paddle._control_mode = Paddle.ControlMode.AI
			# find the ui node in the child and set it active
			for child: Node in paddle.get_children():
				if child is RichTextLabel:
					child.visible = true
					break
		_main_label.visible = true
	else:
		for paddle: Paddle in _paddles:
			if paddle._control_mode == Paddle.ControlMode.PLAYER:
				continue
			if Input.is_key_pressed(paddle._up_key) or Input.is_key_pressed(paddle._down_key):
				paddle._control_mode = Paddle.ControlMode.PLAYER
				# find the ui node in the child and set it inactive
				for child: Node in paddle.get_children():
					if child is RichTextLabel:
						child.visible = false
						break
