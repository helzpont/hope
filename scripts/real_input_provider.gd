extends "res://scripts/input_provider.gd"

# Real Input Provider - uses Godot's Input singleton

class_name RealInputProvider

func get_left_stick_vector() -> Vector2:
	return Input.get_vector("left_stick_left", "left_stick_right", "left_stick_up", "left_stick_down")

func is_action_pressed(action: String) -> bool:
	return Input.is_action_pressed(action)

func get_action_strength(action: String) -> float:
	return Input.get_action_strength(action)