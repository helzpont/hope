extends Node

# Simple CI Test Runner for HOPE
# Runs unit tests manually without GUT framework

var test_scripts = []
var current_test_index = 0
var test_results = {
	"tests": 0,
	"passing": 0,
	"failing": 0
}

func _ready():
	print("🧪 Starting HOPE unit tests (simple runner)...")
	
	# Find all test scripts
	_find_test_scripts("res://tests/")
	
	if test_scripts.size() == 0:
		print("❌ No test scripts found!")
		get_tree().quit(1)
		return
	
	# Run tests
	_run_next_test()

func _find_test_scripts(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".gd"):
				test_scripts.append(path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()

func _run_next_test():
	if current_test_index >= test_scripts.size():
		# All tests finished
		_print_final_results()
		return
	
	var test_script_path = test_scripts[current_test_index]
	print("Running test: ", test_script_path)
	
	# Load and run the test script
	var test_script = load(test_script_path)
	if test_script:
		var test_instance = test_script.new()
		add_child(test_instance)
		
		# Run test methods (simple approach)
		_run_test_methods(test_instance)
		
		test_instance.queue_free()
	else:
		print("❌ Failed to load test script: ", test_script_path)
		test_results.failing += 1
	
	current_test_index += 1
	call_deferred("_run_next_test")

func _run_test_methods(test_instance):
	# Get all methods that start with "test_"
	var methods = []
	for method in test_instance.get_method_list():
		if method.name.begins_with("test_"):
			methods.append(method.name)
	
	test_results.tests += methods.size()
	
	for method_name in methods:
		print("  Running: ", method_name)
		var result = test_instance.call(method_name)
		if result == null or result == true:
			print("  ✅ PASS")
			test_results.passing += 1
		else:
			print("  ❌ FAIL")
			test_results.failing += 1

func _print_final_results():
	print("\n📊 Test Results:")
	print("Tests run: ", test_results.tests)
	print("Passing: ", test_results.passing)
	print("Failing: ", test_results.failing)
	
	if test_results.failing > 0:
		print("❌ Some tests failed!")
		get_tree().quit(1)
	else:
		print("✅ All tests passed!")
		get_tree().quit(0)