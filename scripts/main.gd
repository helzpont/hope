extends Node

# Main scene for testing input system

var input_handler: InputHandler
var test_scene: Node2D
var test_scene_script: GDScript

func _ready():
	# Defer InputHandler creation to avoid timing issues
	call_deferred("_create_input_handler")

func _create_input_handler():
	# Load test scene script once and reuse
	test_scene_script = load("res://scripts/test_scene.gd")

	# Create input handler after scene is fully ready
	input_handler = InputHandler.new()
	add_child(input_handler)

	# Create test scene
	test_scene = Node2D.new()
	test_scene.set_script(test_scene_script)
	add_child(test_scene)

	# Connect signals
	input_handler.connect("action_detected", Callable(test_scene, "_on_action_detected"))

	print("Input system test ready. Use left analog stick to test.")

func _exit_tree():
	# Clean up resources when scene exits
	if input_handler:
		input_handler.queue_free()
	if test_scene:
		test_scene.queue_free()
	if test_scene_script:
		# Note: GDScript resources are managed by Godot, but we can help by clearing references
		test_scene_script = null
