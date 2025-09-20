extends Node2D

# Input Calibration Scene
# Records controller input values and suggests optimal thresholds

# Current input values
var current_magnitude = 0.0
var current_direction = Vector2.ZERO
var max_recorded_magnitude = 0.0

# Current thresholds (from InputHandler)
const CURRENT_DEADZONE = 0.01
const CURRENT_INNER_ENTRY = 0.1
const CURRENT_INNER_EXIT = 0.01
const CURRENT_OUTER_ENTRY = 0.95
const CURRENT_OUTER_EXIT = 0.85

# UI references
@onready var current_values_label = $UI/CurrentValuesLabel
@onready var calibration_label = $UI/CalibrationLabel

func _ready():
	print("🎮 Input Calibration Started")
	print("Move the left stick to maximum in all directions")
	print("Press SPACE to record current max value")
	print("Press ENTER to save calibration")

func _process(_delta):
	# Get current left stick input
	var left_stick = Input.get_vector("left_stick_left", "left_stick_right", "left_stick_up", "left_stick_down")
	current_magnitude = left_stick.length()
	current_direction = left_stick.normalized() if left_stick != Vector2.ZERO else Vector2.ZERO

	# Update UI with current values
	update_current_values_display()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			# Record current magnitude as potential maximum
			if current_magnitude > max_recorded_magnitude:
				max_recorded_magnitude = current_magnitude
				print("📊 New max magnitude recorded: %.3f" % max_recorded_magnitude)
				update_calibration_display()

		elif event.keycode == KEY_ENTER:
			# Save calibration and exit
			save_calibration()
			print("✅ Calibration saved! Exiting...")
			get_tree().quit()

		elif event.keycode == KEY_ESCAPE:
			# Exit without saving
			print("❌ Calibration cancelled")
			get_tree().quit()

func update_current_values_display():
	current_values_label.text = "Current Input:\n" + \
		"Max Magnitude: %.3f\n" % max_recorded_magnitude + \
		"Current Magnitude: %.3f\n" % current_magnitude + \
		"Direction: (%.3f, %.3f)" % [current_direction.x, current_direction.y]

func update_calibration_display():
	var max_val = max_recorded_magnitude

	# Calculate suggested thresholds based on recorded maximum
	var suggested_deadzone = max_val * 0.01 # 1% of max
	var suggested_inner_entry = max_val * 0.15 # 15% of max
	var suggested_inner_exit = max_val * 0.02 # 2% of max
	var suggested_outer_entry = max_val * 0.90 # 90% of max
	var suggested_outer_exit = max_val * 0.80 # 80% of max

	calibration_label.text = "Calibration Results:\n" + \
		"Max Recorded: %.3f\n" % max_val + \
		"Suggested Deadzone: %.3f\n" % suggested_deadzone + \
		"Suggested Inner Entry: %.3f\n" % suggested_inner_entry + \
		"Suggested Inner Exit: %.3f\n" % suggested_inner_exit + \
		"Suggested Outer Entry: %.3f\n" % suggested_outer_entry + \
		"Suggested Outer Exit: %.3f" % suggested_outer_exit

func save_calibration():
	var max_val = max_recorded_magnitude
	if max_val == 0.0:
		print("⚠️  No input recorded! Using default values.")
		return

	# Calculate calibrated thresholds
	var calibrated_deadzone = max_val * 0.01
	var calibrated_inner_entry = max_val * 0.15
	var calibrated_inner_exit = max_val * 0.02
	var calibrated_outer_entry = max_val * 0.90
	var calibrated_outer_exit = max_val * 0.80

	# Save to a calibration file
	var calibration_data = {
		"max_magnitude": max_val,
		"deadzone": calibrated_deadzone,
		"inner_entry_threshold": calibrated_inner_entry,
		"inner_exit_threshold": calibrated_inner_exit,
		"outer_entry_threshold": calibrated_outer_entry,
		"outer_exit_threshold": calibrated_outer_exit,
		"calibration_date": Time.get_datetime_string_from_system()
	}

	var file = FileAccess.open("res://calibration.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(calibration_data, "\t"))
		file.close()
		print("💾 Calibration saved to calibration.json")
	else:
		print("❌ Failed to save calibration file")

	# Also print the values for manual copying
	print("\n📋 Manual Calibration Values:")
	print("Max Magnitude: %.3f" % max_val)
	print("Suggested Deadzone: %.3f" % calibrated_deadzone)
	print("Suggested Inner Entry: %.3f" % calibrated_inner_entry)
	print("Suggested Inner Exit: %.3f" % calibrated_inner_exit)
	print("Suggested Outer Entry: %.3f" % calibrated_outer_entry)
	print("Suggested Outer Exit: %.3f" % calibrated_outer_exit)