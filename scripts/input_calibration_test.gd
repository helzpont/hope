extends Node

# Input Calibration Test
# Run this to see actual controller input values

func _ready():
	print("🎮 Input Calibration Test Started")
	print("Move the left stick in different directions and strengths")
	print("Press ESC to exit")

func _process(_delta):
	var left_stick = Input.get_vector("left_stick_left", "left_stick_right", "left_stick_up", "left_stick_down")
	var magnitude = left_stick.length()
	var direction = left_stick.normalized() if left_stick != Vector2.ZERO else Vector2.ZERO

	# Only print when there's input
	if magnitude > 0.001: # Very small threshold to avoid spam
		print("Left Stick - Raw: (%.3f, %.3f) | Magnitude: %.3f | Direction: (%.3f, %.3f)" %
			  [left_stick.x, left_stick.y, magnitude, direction.x, direction.y])

	# Exit on ESC
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func _input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		print("Calibration test ended")
		get_tree().quit()