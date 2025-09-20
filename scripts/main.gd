extends Node

# Main scene for testing input system

var input_handler: Node
var test_scene: Node

func _ready():
	# Create input handler
	var input_script = load("res://scripts/input_handler.gd")
	input_handler = Node.new()
	input_handler.set_script(input_script)
	add_child(input_handler)
	
	# Create test scene
	test_scene = Node2D.new()
	test_scene.set_script(load("res://scripts/test_scene.gd"))
	add_child(test_scene)
	
	# Connect signals
	input_handler.connect("action_detected", Callable(test_scene, "_on_action_detected"))
	
	print("Input system test ready. Use left analog stick to test.")