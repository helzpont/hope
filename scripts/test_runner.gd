extends Node

# CI Test Runner for HOPE
# Runs all unit tests in headless mode for CI/CD

@onready var gut = $GutControl

func _ready():
	# Configure GUT for headless testing
	if gut:
		gut.connect("tests_finished", Callable(self, "_on_tests_finished"))
		gut.connect("test_script_finished", Callable(self, "_on_test_script_finished"))

		# Set up for headless mode
		gut.set_should_print_to_console(true)
		gut.set_should_exit_on_success(false)  # Don't exit automatically
		gut.set_should_exit_on_failure(false)

		# Configure JUnit XML export for CI
		gut.set_junit_xml_file("user://test_results.xml")
		gut.set_export_json_file("user://test_results.json")

		# Run tests
		gut.test_scripts(["res://tests/"])
	else:
		print("ERROR: GUT not found!")
		get_tree().quit(1)

func _on_test_script_finished(script_summary):
	print("Test script finished: ", script_summary)

func _on_tests_finished():
	var results = gut.get_summary()
	print("All tests finished!")
	print("Tests run: ", results.tests)
	print("Passing: ", results.passing)
	print("Failing: ", results.failing)

	# Export results
	gut.export_json_file("user://test_results.json")
	gut.export_junit_xml("user://test_results.xml")

	if results.failing > 0:
		print("Some tests failed!")
		get_tree().quit(1)
	else:
		print("All tests passed!")
		get_tree().quit(0)