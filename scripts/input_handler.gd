extends Node

# HOPE Input Handler
# Processes analog stick input with dual-circle system and hysteresis

class_name InputHandler

# Configuration
const INNER_THRESHOLD = 0.85 # 85% for inner circle
const OUTER_THRESHOLD = 0.95 # 95% for outer circle (hysteresis buffer)
const DEADZONE = 0.1 # Ignore small inputs

# Current state
var current_magnitude = 0.0
var current_direction = Vector2.ZERO
var in_outer_circle = false
var last_outer_state = false

# Action signals
signal action_detected(action_name: String, direction: Vector2, circle: String, magnitude: float)

func _process(_delta):
	# Get left stick input
	var input_vector = Input.get_vector("left_stick_left", "left_stick_right", "left_stick_up", "left_stick_down")
	
	# Apply deadzone
	if input_vector.length() < DEADZONE:
		input_vector = Vector2.ZERO
	
	current_magnitude = input_vector.length()
	current_direction = input_vector.normalized() if input_vector != Vector2.ZERO else Vector2.ZERO
	
	# Update circle state with hysteresis
	update_circle_state()
	
	# Detect actions based on current state
	detect_actions()

func update_circle_state():
	# Hysteresis logic: once in outer, need to drop below 85% to exit
	# Once in inner, need to exceed 95% to enter outer
	if in_outer_circle:
		if current_magnitude < INNER_THRESHOLD:
			in_outer_circle = false
	else:
		if current_magnitude > OUTER_THRESHOLD:
			in_outer_circle = true

func detect_actions():
	# For now, just detect single direction holds
	if current_direction != Vector2.ZERO:
		var action = "walk" if not in_outer_circle else "dash"
		var circle_str = "Outer" if in_outer_circle else "Inner"
		emit_signal("action_detected", action, current_direction, circle_str, current_magnitude)
	else:
		# No input
		emit_signal("action_detected", "idle", Vector2.ZERO, "None", 0.0)