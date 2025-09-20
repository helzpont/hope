extends Node

# Unit tests for InputHandler basic movements

var input_handler: InputHandler
var received_actions = []
var test_input_provider: TestInputProvider

func before_each():
	test_input_provider = TestInputProvider.new()
	input_handler = InputHandler.new(test_input_provider)
	add_child(input_handler)
	received_actions.clear()
	input_handler.connect("action_detected", Callable(self, "_on_action_detected"))

func after_each():
	if input_handler:
		input_handler.queue_free()
	if test_input_provider:
		test_input_provider.queue_free()

func _on_action_detected(action_name: String, direction: Vector2, circle: String, magnitude: float):
	received_actions.append({
		"action": action_name,
		"direction": direction,
		"circle": circle,
		"magnitude": magnitude
	})

func test_deadzone_filtering():
	before_each()
	
	# Test that very small inputs are filtered out (below 0.01)
	_simulate_input(Vector2(0.005, 0.005)) # Below deadzone
	input_handler._handle_input(0.016, test_input_provider)

	assert_eq(received_actions.size(), 1, "Should detect one action")
	assert_eq(received_actions[0]["action"], "idle", "Very small input should be filtered to idle")
	
	after_each()

func test_hysteresis_inner_circle():
	before_each()
	
	# Start with no input
	_simulate_input(Vector2.ZERO)
	input_handler._handle_input(0.016, test_input_provider)
	assert_eq(received_actions[0]["action"], "idle", "Should start idle")
	
	# Cross entry threshold (0.1) - should enter inner circle and walk
	received_actions.clear()
	_simulate_input(Vector2(0.15, 0.0)) # 15% magnitude
	input_handler._handle_input(0.016, test_input_provider)
	assert_eq(received_actions[0]["action"], "walk", "Should walk when entering inner circle")
	assert_eq(received_actions[0]["circle"], "Inner", "Should be in inner circle")
	
	# Drop below exit threshold (0.01) but above deadzone - should stay walking (hysteresis)
	received_actions.clear()
	_simulate_input(Vector2(0.03, 0.0)) # 3% magnitude
	input_handler._handle_input(0.016, test_input_provider)
	assert_eq(received_actions[0]["action"], "walk", "Should keep walking (hysteresis)")
	assert_eq(received_actions[0]["circle"], "Inner", "Should stay in inner circle")
	
	# Drop below exit threshold - should go idle
	received_actions.clear()
	_simulate_input(Vector2(0.009, 0.0)) # 0.9% magnitude
	input_handler._handle_input(0.016, test_input_provider)
	assert_eq(received_actions[0]["action"], "idle", "Should go idle below exit threshold")
	assert_eq(received_actions[0]["circle"], "None", "Should be outside inner circle")
	
	after_each()

func test_inner_circle_walk():
	before_each()

	# Simulate moderate input (inner circle)
	_simulate_input(Vector2(0.5, 0.0)) # 50% magnitude
	input_handler._handle_input(0.016, test_input_provider)

	assert_eq(received_actions.size(), 1, "Should detect one action")
	assert_eq(received_actions[0]["action"], "walk", "Inner circle should trigger walk")
	assert_eq(received_actions[0]["circle"], "Inner", "Should be in inner circle")

	after_each()

func test_outer_circle_dash():
	before_each()

	# First enter outer circle
	_simulate_input(Vector2(0.98, 0.0)) # 98% magnitude
	input_handler._handle_input(0.016, test_input_provider)

	assert_eq(received_actions.size(), 1, "Should detect one action")
	assert_eq(received_actions[0]["action"], "dash", "Outer circle should trigger dash")
	assert_eq(received_actions[0]["circle"], "Outer", "Should be in outer circle")

	after_each()

func test_hysteresis_buffer():
	before_each()

	# Enter outer circle
	_simulate_input(Vector2(0.98, 0.0))
	input_handler._handle_input(0.016, test_input_provider)
	assert_eq(received_actions[0]["circle"], "Outer", "Should enter outer circle")

	# Try to exit with value in hysteresis zone (90%)
	received_actions.clear()
	_simulate_input(Vector2(0.9, 0.0))
	input_handler._handle_input(0.016, test_input_provider)

	assert_eq(received_actions[0]["circle"], "Outer", "Should stay in outer circle (hysteresis)")

	# Exit with value below inner threshold
	received_actions.clear()
	_simulate_input(Vector2(0.7, 0.0))
	input_handler._handle_input(0.016, test_input_provider)

	assert_eq(received_actions[0]["circle"], "Inner", "Should exit outer circle")

	after_each()

func test_direction_normalization():
	before_each()

	# Test diagonal input
	_simulate_input(Vector2(0.6, 0.6)) # Should normalize to unit vector
	input_handler._handle_input(0.016, test_input_provider)

	var direction = received_actions[0]["direction"]
	assert_almost_eq(direction.length(), 1.0, 0.01, "Direction should be normalized")

	after_each()

func test_no_input_idle():
	before_each()

	# No input
	_simulate_input(Vector2.ZERO)
	input_handler._handle_input(0.016, test_input_provider)

	assert_eq(received_actions[0]["action"], "idle", "No input should trigger idle")

	after_each()

func test_magnitude_calculation():
	before_each()

	_simulate_input(Vector2(0.8, 0.0))
	input_handler._handle_input(0.016, test_input_provider)

	assert_almost_eq(received_actions[0]["magnitude"], 0.8, 0.01, "Magnitude should be correct")

	after_each()

func _simulate_input(input_vector: Vector2):
	# Use the test input provider to inject input
	test_input_provider.set_left_stick_vector(input_vector)

# Simple assertion functions
func assert_eq(actual, expected, message = ""):
	if actual != expected:
		print("❌ ASSERT FAILED: ", message)
		print("  Expected: ", expected)
		print("  Actual: ", actual)
		return false
	else:
		print("✅ ASSERT PASSED: ", message)
		return true

func assert_almost_eq(actual, expected, tolerance = 0.01, message = ""):
	if abs(actual - expected) > tolerance:
		print("❌ ASSERT FAILED: ", message)
		print("  Expected: ", expected)
		print("  Actual: ", actual)
		return false
	else:
		print("✅ ASSERT PASSED: ", message)
		return true