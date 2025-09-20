extends "res://scripts/input_provider.gd"

# Test Input Provider - allows injecting mock input for testing

class_name TestInputProvider

var mock_left_stick_vector: Vector2 = Vector2.ZERO
var mock_action_states: Dictionary = {}
var mock_action_strengths: Dictionary = {}

func get_left_stick_vector() -> Vector2:
	return mock_left_stick_vector

func is_action_pressed(action: String) -> bool:
	return mock_action_states.get(action, false)

func get_action_strength(action: String) -> float:
	return mock_action_strengths.get(action, 0.0)

# Test helper methods
func set_left_stick_vector(vector: Vector2):
	mock_left_stick_vector = vector

func set_action_pressed(action: String, pressed: bool):
	mock_action_states[action] = pressed

func set_action_strength(action: String, strength: float):
	mock_action_strengths[action] = strength

func reset():
	mock_left_stick_vector = Vector2.ZERO
	mock_action_states.clear()
	mock_action_strengths.clear()