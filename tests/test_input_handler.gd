extends GutTest

# Unit tests for InputHandler basic movements

class TestInputHandler:
	extends GutTest

	var input_handler: InputHandler
	var received_actions = []

	func before_each():
		input_handler = InputHandler.new()
		add_child(input_handler)
		received_actions.clear()
		input_handler.connect("action_detected", Callable(self, "_on_action_detected"))

	func after_each():
		if input_handler:
			input_handler.queue_free()

	func _on_action_detected(action_name: String, direction: Vector2, circle: String, magnitude: float):
		received_actions.append({
			"action": action_name,
			"direction": direction,
			"circle": circle,
			"magnitude": magnitude
		})

	func test_deadzone_filtering():
		# Test that small inputs are filtered out
		watch_signals(input_handler)

		# Simulate small input below deadzone
		_simulate_input(Vector2(0.05, 0.05))
		input_handler._process(0.016)

		assert_eq(received_actions.size(), 1, "Should detect one action")
		assert_eq(received_actions[0]["action"], "idle", "Small input should be filtered to idle")

	func test_inner_circle_walk():
		watch_signals(input_handler)

		# Simulate moderate input (inner circle)
		_simulate_input(Vector2(0.5, 0.0))  # 50% magnitude
		input_handler._process(0.016)

		assert_eq(received_actions.size(), 1, "Should detect one action")
		assert_eq(received_actions[0]["action"], "walk", "Inner circle should trigger walk")
		assert_eq(received_actions[0]["circle"], "Inner", "Should be in inner circle")

	func test_outer_circle_dash():
		watch_signals(input_handler)

		# First enter outer circle
		_simulate_input(Vector2(0.98, 0.0))  # 98% magnitude
		input_handler._process(0.016)

		assert_eq(received_actions.size(), 1, "Should detect one action")
		assert_eq(received_actions[0]["action"], "dash", "Outer circle should trigger dash")
		assert_eq(received_actions[0]["circle"], "Outer", "Should be in outer circle")

	func test_hysteresis_buffer():
		watch_signals(input_handler)

		# Enter outer circle
		_simulate_input(Vector2(0.98, 0.0))
		input_handler._process(0.016)
		assert_eq(received_actions[0]["circle"], "Outer", "Should enter outer circle")

		# Try to exit with value in hysteresis zone (90%)
		received_actions.clear()
		_simulate_input(Vector2(0.9, 0.0))
		input_handler._process(0.016)

		assert_eq(received_actions[0]["circle"], "Outer", "Should stay in outer circle (hysteresis)")

		# Exit with value below inner threshold
		received_actions.clear()
		_simulate_input(Vector2(0.7, 0.0))
		input_handler._process(0.016)

		assert_eq(received_actions[0]["circle"], "Inner", "Should exit outer circle")

	func test_direction_normalization():
		watch_signals(input_handler)

		# Test diagonal input
		_simulate_input(Vector2(0.6, 0.6))  # Should normalize to unit vector
		input_handler._process(0.016)

		var direction = received_actions[0]["direction"]
		assert_almost_eq(direction.length(), 1.0, 0.01, "Direction should be normalized")

	func test_no_input_idle():
		watch_signals(input_handler)

		# No input
		_simulate_input(Vector2.ZERO)
		input_handler._process(0.016)

		assert_eq(received_actions[0]["action"], "idle", "No input should trigger idle")

	func test_magnitude_calculation():
		watch_signals(input_handler)

		_simulate_input(Vector2(0.8, 0.0))
		input_handler._process(0.016)

		assert_almost_eq(received_actions[0]["magnitude"], 0.8, 0.01, "Magnitude should be correct")

	func _simulate_input(input_vector: Vector2):
		# Mock the Input.get_vector call by directly setting the input
		# In a real test, you might need to mock the Input singleton
		input_handler.current_magnitude = input_vector.length()
		input_handler.current_direction = input_vector.normalized() if input_vector != Vector2.ZERO else Vector2.ZERO