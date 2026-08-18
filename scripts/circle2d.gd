@tool
class_name Circle2D
extends Node2D

@export var _radius: float = 0.5
@export var _line_thickness: float = 0.1
@export var _filled: bool = true
@export var _fill_color: Color = Color.WHITE


func _draw() -> void:
	draw_circle(Vector2.ZERO, _radius, _fill_color, _filled, _line_thickness)
