# Test-Driven Development Guide for HOPE

## Testing Philosophy

HOPE's unique stick-only control scheme and physics-based gameplay require comprehensive testing to ensure the game feels fair, responsive, and accessible. This guide outlines a test-driven development approach that prioritizes player experience and system reliability.

## Testing Framework Setup

### Godot Testing Tools
```gdscript
# Install GUT (Godot Unit Test) framework
# Add to project.godot:
[autoload]
GUT = "res://addons/gut/gut.gd"

# Test runner scene
# tests/TestRunner.tscn with GUT node configured
```

### Test Directory Structure
```
tests/
├── unit/
│   ├── test_balance_system.gd
│   ├── test_input_manager.gd
│   ├── test_pole_physics.gd
│   └── test_enemy_ai.gd
├── integration/
│   ├── test_player_movement.gd
│   ├── test_room_completion.gd
│   └── test_save_system.gd
├── performance/
│   ├── test_physics_performance.gd
│   └── test_memory_usage.gd
└── accessibility/
    ├── test_controller_support.gd
    ├── test_visual_feedback.gd
    └── test_audio_cues.gd
```

## Test-Driven Development Workflow

### 1. Red Phase: Write Failing Tests
Before implementing any feature, write tests that define the expected behavior.

```gdscript
# Example: test_balance_system.gd
extends GutTest

func test_stable_balance_with_centered_pole():
    var balance_system = BalanceSystem.new()
    balance_system.pole_angle = 0.0
    balance_system.velocity = Vector2.ZERO
    balance_system.external_forces = Vector2.ZERO
    
    var result = balance_system.calculate_balance_state()
    
    assert_lt(result, 0.3, "Centered pole should be stable")

func test_unstable_balance_with_tilted_pole():
    var balance_system = BalanceSystem.new()
    balance_system.pole_angle = 45.0  # degrees
    balance_system.velocity = Vector2.ZERO
    balance_system.external_forces = Vector2.ZERO
    
    var result = balance_system.calculate_balance_state()
    
    assert_between(result, 0.3, 0.7, "Tilted pole should be unstable")

func test_falling_balance_with_extreme_angle():
    var balance_system = BalanceSystem.new()
    balance_system.pole_angle = 80.0  # degrees
    balance_system.velocity = Vector2.ZERO
    balance_system.external_forces = Vector2.ZERO
    
    var result = balance_system.calculate_balance_state()
    
    assert_gt(result, 0.7, "Extreme pole angle should cause falling")
```

### 2. Green Phase: Implement Minimum Code
Write just enough code to make the tests pass.

```gdscript
# BalanceSystem.gd - minimal implementation
class_name BalanceSystem

var pole_angle: float = 0.0
var velocity: Vector2 = Vector2.ZERO
var external_forces: Vector2 = Vector2.ZERO

func calculate_balance_state() -> float:
    var angle_factor = abs(pole_angle) / 90.0  # Normalize to 0-1
    var velocity_factor = velocity.length() / 200.0  # Max expected velocity
    var force_factor = external_forces.length() / 100.0  # Max expected force
    
    return (angle_factor + velocity_factor + force_factor) / 3.0
```

### 3. Refactor Phase: Improve Code Quality
Enhance the implementation while maintaining test coverage.

```gdscript
# Improved BalanceSystem.gd
class_name BalanceSystem

@export var max_stable_angle: float = 30.0
@export var max_stable_velocity: float = 150.0
@export var max_external_force: float = 80.0

var pole_angle: float = 0.0
var velocity: Vector2 = Vector2.ZERO
var external_forces: Vector2 = Vector2.ZERO

func calculate_balance_state() -> float:
    var angle_factor = _calculate_angle_factor()
    var velocity_factor = _calculate_velocity_factor()
    var force_factor = _calculate_force_factor()
    
    return (angle_factor + velocity_factor + force_factor) / 3.0

func _calculate_angle_factor() -> float:
    return clamp(abs(pole_angle) / max_stable_angle, 0.0, 1.0)

func _calculate_velocity_factor() -> float:
    return clamp(velocity.length() / max_stable_velocity, 0.0, 1.0)

func _calculate_force_factor() -> float:
    return clamp(external_forces.length() / max_external_force, 0.0, 1.0)
```

## Core System Test Suites

### Input System Tests
```gdscript
# test_input_manager.gd
extends GutTest

var input_manager: InputManager
var mock_input: MockInput

func before_each():
    input_manager = InputManager.new()
    mock_input = MockInput.new()
    input_manager.set_input_source(mock_input)

func test_left_stick_movement():
    mock_input.set_stick_input(InputManager.LEFT_STICK, Vector2(0.5, 0.0))
    
    var movement = input_manager.get_movement_input()
    
    assert_eq(movement.x, 0.5, "Left stick X should map to movement")
    assert_eq(movement.y, 0.0, "Left stick Y should not affect horizontal movement")

func test_dead_zone_filtering():
    mock_input.set_stick_input(InputManager.LEFT_STICK, Vector2(0.05, 0.0))
    
    var movement = input_manager.get_movement_input()
    
    assert_eq(movement, Vector2.ZERO, "Small inputs should be filtered by dead zone")

func test_right_stick_camera_control():
    mock_input.set_stick_input(InputManager.RIGHT_STICK, Vector2(0.8, 0.0))
    
    var camera_input = input_manager.get_camera_input()
    
    assert_eq(camera_input.x, 0.8, "Right stick X should control camera pan")

func test_right_stick_click_interaction():
    mock_input.set_stick_click(InputManager.RIGHT_STICK, true)
    
    var interaction = input_manager.get_interaction_input()
    
    assert_true(interaction, "Right stick click should trigger interaction")
```

### Physics System Tests
```gdscript
# test_pole_physics.gd
extends GutTest

var pole: PolePhysics
var hope: CharacterBody2D

func before_each():
    pole = PolePhysics.new()
    hope = CharacterBody2D.new()
    pole.attach_to_character(hope)

func test_pole_follows_character_movement():
    hope.velocity = Vector2(100, 0)
    
    pole.update_physics(0.016)  # 60fps delta
    
    assert_gt(pole.angular_velocity, 0, "Pole should rotate when character moves")

func test_pole_collision_with_wall():
    var wall = StaticBody2D.new()
    pole.position = Vector2(100, 100)
    
    var collision = pole.check_collision(wall)
    
    assert_true(collision, "Pole should detect collision with wall")

func test_pole_momentum_conservation():
    pole.angular_velocity = 2.0
    var initial_energy = pole.calculate_kinetic_energy()
    
    pole.update_physics(0.016)
    
    var final_energy = pole.calculate_kinetic_energy()
    assert_almost_eq(initial_energy, final_energy, 0.1, "Energy should be conserved")
```

### Enemy AI Tests
```gdscript
# test_enemy_ai.gd
extends GutTest

var patrol_bot: PatrolBot
var player: CharacterBody2D

func before_each():
    patrol_bot = PatrolBot.new()
    player = CharacterBody2D.new()
    patrol_bot.set_patrol_points([Vector2(0, 0), Vector2(200, 0)])

func test_patrol_movement():
    patrol_bot.position = Vector2(0, 0)
    
    patrol_bot.update_ai(0.016)
    
    assert_gt(patrol_bot.position.x, 0, "Bot should move toward next patrol point")

func test_patrol_direction_change():
    patrol_bot.position = Vector2(200, 0)  # At end of patrol
    
    patrol_bot.update_ai(0.016)
    
    assert_lt(patrol_bot.velocity.x, 0, "Bot should reverse direction at patrol end")

func test_collision_with_player():
    patrol_bot.position = Vector2(100, 100)
    player.position = Vector2(105, 100)  # Close to bot
    
    var collision = patrol_bot.check_player_collision(player)
    
    assert_true(collision, "Bot should detect collision with nearby player")
```

## Integration Test Scenarios

### Room Completion Tests
```gdscript
# test_room_completion.gd
extends GutTest

var room: Room
var player: Player

func before_each():
    room = preload("res://scenes/rooms/Room01.tscn").instantiate()
    player = room.get_node("Player")

func test_tutorial_room_completion():
    # Simulate player movement to exit
    player.position = room.start_position
    
    _simulate_movement_to_exit()
    
    assert_true(room.is_completed(), "Tutorial room should be completable")

func test_room_failure_and_restart():
    player.position = room.start_position
    
    _simulate_balance_failure()
    
    assert_eq(player.position, room.start_position, "Player should restart at beginning")

func _simulate_movement_to_exit():
    # Simulate stick inputs to reach exit
    var steps = 100
    for i in steps:
        player.handle_input(Vector2(0.5, 0.0), Vector2.ZERO, false)
        player.update_physics(0.016)

func _simulate_balance_failure():
    # Simulate extreme pole angle
    player.pole.angle = deg_to_rad(90)
    player.update_balance(0.016)
```

### Save System Tests
```gdscript
# test_save_system.gd
extends GutTest

var save_system: SaveSystem

func before_each():
    save_system = SaveSystem.new()

func test_save_game_progress():
    var game_state = {
        "current_room": 5,
        "completed_rooms": [1, 2, 3, 4],
        "settings": {"master_volume": 0.8}
    }
    
    save_system.save_game(game_state)
    var loaded_state = save_system.load_game()
    
    assert_eq(loaded_state.current_room, 5, "Current room should be saved")
    assert_eq(loaded_state.completed_rooms.size(), 4, "Completed rooms should be saved")

func test_save_file_corruption_handling():
    save_system.corrupt_save_file()  # Test helper
    
    var loaded_state = save_system.load_game()
    
    assert_not_null(loaded_state, "Should return default state on corruption")
    assert_eq(loaded_state.current_room, 1, "Should start from beginning on corruption")
```

## Performance Testing

### Physics Performance Tests
```gdscript
# test_physics_performance.gd
extends GutTest

func test_balance_calculation_performance():
    var balance_system = BalanceSystem.new()
    var start_time = Time.get_time_dict_from_system()
    
    # Run 1000 balance calculations
    for i in 1000:
        balance_system.pole_angle = randf_range(-90, 90)
        balance_system.velocity = Vector2(randf_range(-200, 200), 0)
        balance_system.calculate_balance_state()
    
    var end_time = Time.get_time_dict_from_system()
    var duration = (end_time.hour * 3600 + end_time.minute * 60 + end_time.second) - \
                   (start_time.hour * 3600 + start_time.minute * 60 + start_time.second)
    
    assert_lt(duration, 0.016, "1000 calculations should complete within one frame")

func test_memory_usage_stability():
    var initial_memory = OS.get_static_memory_usage_by_type()
    
    # Simulate 10 seconds of gameplay
    for i in 600:  # 60fps * 10 seconds
        _simulate_frame()
    
    var final_memory = OS.get_static_memory_usage_by_type()
    var memory_growth = final_memory - initial_memory
    
    assert_lt(memory_growth, 1024 * 1024, "Memory growth should be less than 1MB")
```

## Accessibility Testing

### Controller Support Tests
```gdscript
# test_controller_support.gd
extends GutTest

func test_xbox_controller_mapping():
    var xbox_input = XboxControllerInput.new()
    var input_manager = InputManager.new()
    input_manager.set_input_source(xbox_input)
    
    xbox_input.simulate_stick_input("left_stick", Vector2(0.5, 0.0))
    
    var movement = input_manager.get_movement_input()
    assert_eq(movement.x, 0.5, "Xbox left stick should map correctly")

func test_playstation_controller_mapping():
    var ps_input = PlayStationControllerInput.new()
    var input_manager = InputManager.new()
    input_manager.set_input_source(ps_input)
    
    ps_input.simulate_stick_input("left_stick", Vector2(0.5, 0.0))
    
    var movement = input_manager.get_movement_input()
    assert_eq(movement.x, 0.5, "PlayStation left stick should map correctly")

func test_dead_zone_customization():
    var input_manager = InputManager.new()
    input_manager.set_dead_zone(0.2)
    
    input_manager.process_stick_input(Vector2(0.15, 0.0))
    
    var movement = input_manager.get_movement_input()
    assert_eq(movement, Vector2.ZERO, "Custom dead zone should filter small inputs")
```

### Visual Feedback Tests
```gdscript
# test_visual_feedback.gd
extends GutTest

func test_balance_indicator_visibility():
    var balance_ui = BalanceIndicator.new()
    balance_ui.set_balance_state(0.8)  # Unstable
    
    var color = balance_ui.get_indicator_color()
    
    assert_ne(color, Color.GREEN, "Unstable balance should not show green")
    assert_true(color.r > 0.5, "Unstable balance should show warning color")

func test_colorblind_accessibility():
    var balance_ui = BalanceIndicator.new()
    balance_ui.enable_colorblind_mode(true)
    balance_ui.set_balance_state(0.8)
    
    var pattern = balance_ui.get_indicator_pattern()
    
    assert_not_null(pattern, "Colorblind mode should use patterns, not just color")
```

## Automated Testing Pipeline

### Continuous Integration Setup
```yaml
# .github/workflows/test.yml
name: Run Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Godot
        uses: lihop/setup-godot@v1
        with:
          godot-version: "4.1"
      - name: Run Unit Tests
        run: godot --headless --script tests/run_tests.gd
      - name: Run Integration Tests
        run: godot --headless --script tests/run_integration_tests.gd
      - name: Generate Test Report
        run: godot --headless --script tests/generate_report.gd
```

### Test Coverage Goals
- **Unit Tests**: 90% code coverage for core systems
- **Integration Tests**: 100% room completion scenarios
- **Performance Tests**: All systems maintain 60fps
- **Accessibility Tests**: Support for major controller types

## Manual Testing Checklist

### New Player Experience
- [ ] Can complete tutorial without external help
- [ ] Controls feel intuitive within 2 minutes
- [ ] Failure states are clearly communicated
- [ ] Progress is saved automatically

### Accessibility Verification
- [ ] Works with Xbox, PlayStation, and generic controllers
- [ ] Visual feedback is clear without audio
- [ ] Audio cues are clear without visual
- [ ] Customizable dead zones work correctly

### Performance Validation
- [ ] Maintains 60fps on minimum spec hardware
- [ ] Memory usage remains stable over extended play
- [ ] Loading times are under 3 seconds per room
- [ ] No frame drops during complex physics interactions

### Story Integration
- [ ] Narrative elements don't interfere with gameplay
- [ ] Environmental storytelling is clear and optional
- [ ] Character progression feels meaningful
- [ ] Ending reflects player's journey

Remember: Tests should be written before implementation, run frequently during development, and maintained as the codebase evolves. The goal is to catch issues early and ensure HOPE provides a consistent, accessible, and enjoyable experience for all players.