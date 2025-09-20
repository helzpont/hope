# HOPE Testing Setup

This directory contains the unit testing setup for the HOPE game project using GUT (Godot Unit Test) framework.

## 🧪 Test Structure

```
tests/
├── test_input_handler.gd    # Unit tests for InputHandler basic movements
└── ...                      # Additional test files

scripts/
├── test_runner.gd           # CI test runner script

test_runner.tscn             # Test runner scene
run_tests.sh                 # Linux/macOS CI script
run_tests.bat                # Windows CI script
.github/workflows/ci.yml     # GitHub Actions workflow
```

## 🏃 Running Tests

### Local Development

1. **Via Godot Editor:**

   - Open the project in Godot
   - Run the `test_runner.tscn` scene
   - Tests will execute and show results in the console

2. **Via Command Line:**

   ```bash
   # Linux/macOS
   ./run_tests.sh

   # Windows
   run_tests.bat

   # Manual Godot command
   godot --headless --path . --scene res://test_runner.tscn --quit
   ```

### CI/CD

The project includes GitHub Actions workflow (`.github/workflows/ci.yml`) that:

- Runs on pushes and pull requests to main/develop branches
- Uses Ubuntu with Godot 4.4
- Executes all unit tests in headless mode
- Uploads test results as artifacts

## 📊 Test Coverage

### InputHandler Tests (`test_input_handler.gd`)

- **Deadzone Filtering**: Verifies small inputs are filtered out
- **Inner Circle Walk**: Tests moderate input triggers walk action
- **Outer Circle Dash**: Tests full input triggers dash action
- **Hysteresis Buffer**: Ensures smooth transitions between circles
- **Direction Normalization**: Verifies input vectors are normalized
- **No Input Idle**: Tests idle state when no input detected
- **Magnitude Calculation**: Validates correct magnitude values

## 🔧 Test Configuration

### GUT Settings

- **Headless Mode**: Optimized for CI/CD pipelines
- **JUnit XML Export**: Generates `test_results.xml` for CI integration
- **JSON Export**: Creates `test_results.json` for detailed analysis
- **Console Output**: All test results printed to console

### Input Simulation

Tests use direct property manipulation to simulate input:

```gdscript
input_handler.current_magnitude = 0.8
input_handler.current_direction = Vector2(0.8, 0.0)
```

## 📈 CI Integration

### Exit Codes

- `0`: All tests passed
- `1`: Some tests failed

### Artifacts

- `test_results.json`: Detailed test results
- `test_results.xml`: JUnit XML format for CI tools

### Supported Platforms

- ✅ Linux (Ubuntu)
- ✅ macOS
- ✅ Windows
- ✅ GitHub Actions

## 🚀 Adding New Tests

1. Create new test file in `tests/` directory
2. Extend `GutTest` class
3. Use `before_each()` and `after_each()` for setup/cleanup
4. Follow naming convention: `test_descriptive_name()`

Example:

```gdscript
extends GutTest

func test_new_feature():
    # Arrange
    var component = Component.new()

    # Act
    var result = component.do_something()

    # Assert
    assert_eq(result, expected_value)
```

## 🐛 Debugging Tests

- Run individual test scripts via GUT panel in Godot editor
- Check console output for detailed error messages
- Use `gut.p()` for debug printing
- Enable signal watching with `watch_signals()`

## 📋 Test Maintenance

- Keep test files organized by feature/component
- Update tests when changing game mechanics
- Ensure tests run in under 30 seconds for CI efficiency
- Document complex test scenarios in comments
