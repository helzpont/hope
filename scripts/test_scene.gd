extends Node2D

# Test scene for InputHandler
# Displays detected actions and input state

var status_label: Label

var last_action = ""
var last_circle = ""
var last_magnitude = 0.0
var last_direction = Vector2.ZERO

func _ready():
	status_label = Label.new()
	add_child(status_label)
	status_label.position = Vector2(10, 10)

func _on_action_detected(action_name: String, direction: Vector2, circle: String, magnitude: float):
	var dir_str = "None" if direction == Vector2.ZERO else str(direction.round())
	
	status_label.text = "Action: %s\nCircle: %s\nMagnitude: %.2f\nDirection: %s" % [action_name, circle, magnitude, dir_str]

func _process(_delta):
	# Update display
	pass