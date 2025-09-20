extends Node

# Input Provider Interface
# Abstract interface for input sources (real Input singleton or test mocks)

class_name InputProvider

# Get the left stick input vector
func get_left_stick_vector() -> Vector2:
	push_error("InputProvider.get_left_stick_vector() must be implemented by subclass")
	return Vector2.ZERO

# Check if a specific action is pressed
func is_action_pressed(_action: String) -> bool:
	push_error("InputProvider.is_action_pressed() must be implemented by subclass")
	return false

# Get the strength of a specific action
func get_action_strength(_action: String) -> float:
	push_error("InputProvider.get_action_strength() must be implemented by subclass")
	return 0.0