extends Node

# HOPE Input Handler
# Processes analog stick input with dual-circle system and hysteresis

class_name InputHandler

# Configuration
const INNER_THRESHOLD = 0.85 # 85% for inner circle
const OUTER_THRESHOLD = 0.95 # 95% for outer circle (hysteresis buffer)
const DEADZONE = 0.01 # Ignore very small inputs (0.0 to 0.01)
const INNER_ENTRY_THRESHOLD = 0.1 # Enter inner circle at 10%
const INNER_EXIT_THRESHOLD = 0.01 # Exit inner circle at 1% (hysteresis)

# Current state
var current_magnitude = 0.0
var current_direction = Vector2.ZERO
var in_outer_circle = false
var in_inner_circle = false # New: hysteresis state for inner circle

# Dependency injection
var input_provider: InputProvider

# Initialization flag
var is_ready = false

# Action signals
signal action_detected(action_name: String, direction: Vector2, circle: String, magnitude: float)

func _ready():
	# Mark as ready after scene initialization
	is_ready = true

func _init(input_provider_instance: InputProvider = null):
	# Store the input provider instance, but don't create RealInputProvider yet
	if input_provider_instance != null:
		input_provider = input_provider_instance
	# input_provider will be null initially for default case, created lazily in _handle_input

func _process(delta):
	# Only process input after scene is fully ready
	if is_ready:
		_handle_input(delta, input_provider)

func _handle_input(_delta: float, input_provider_instance: InputProvider):
	# Lazily create RealInputProvider if none provided
	if input_provider_instance == null:
		if input_provider == null:
			input_provider = RealInputProvider.new()
		input_provider_instance = input_provider
	
	# Get left stick input from the injected provider
	var input_vector = input_provider_instance.get_left_stick_vector()
	var raw_magnitude = input_vector.length()
	
	# Apply deadzone
	if raw_magnitude < DEADZONE:
		input_vector = Vector2.ZERO
	
	current_magnitude = input_vector.length()
	current_direction = input_vector.normalized() if input_vector != Vector2.ZERO else Vector2.ZERO

	# Update circle states with hysteresis
	update_circle_states()

	# Detect actions based on current state
	detect_actions()

func update_circle_states():
	# Update outer circle with hysteresis
	if in_outer_circle:
		if current_magnitude < INNER_THRESHOLD:
			in_outer_circle = false
	else:
		if current_magnitude > OUTER_THRESHOLD:
			in_outer_circle = true
	
	# Update inner circle with hysteresis
	if in_inner_circle:
		if current_magnitude < INNER_EXIT_THRESHOLD:
			in_inner_circle = false
	else:
		if current_magnitude > INNER_ENTRY_THRESHOLD:
			in_inner_circle = true

func detect_actions():
	# Detect actions based on input zones and circle state
	if current_direction != Vector2.ZERO:
		var action: String
		var circle_str: String
		
		if in_outer_circle:
			# Outer circle: Always dash
			action = "dash"
			circle_str = "Outer"
		else:
			# Inner circle with hysteresis
			if in_inner_circle:
				action = "walk"
				circle_str = "Inner"
			else:
				# Below inner circle threshold
				action = "idle"
				circle_str = "None"
		
		emit_signal("action_detected", action, current_direction, circle_str, current_magnitude)
	else:
		# No input
		emit_signal("action_detected", "idle", Vector2.ZERO, "None", 0.0)

func _exit_tree():
	# Clean up input provider when node exits
	if input_provider:
		input_provider.queue_free()
		input_provider = null