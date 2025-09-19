# Test-Driven Development Guide for HOPE

## Testing Philosophy

HOPE's unique stick-only control scheme and arcade-style movement with fighting game inputs require comprehensive testing to ensure the game feels responsive, reliable, and accessible. This guide outlines a test-driven development approach that prioritizes player experience and motion input reliability.

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
│   ├── test_motion_input.gd
│   ├── test_move_system.gd
│   ├── test_player_controller.gd
│   └── test_enemy_ai.gd
├── integration/
│   ├── test_room_progression.gd
│   ├── test_cutscene_system.gd
│   └── test_training_rooms.gd
├── performance/
│   ├── test_animation_performance.gd
│   └── test_memory_usage.gd
└── accessibility/
    ├── test_controller_support.gd
    ├── test_motion_tolerance.gd
    └── test_visual_feedback.gd
```

## Test-Driven Development Workflow

### 1. Red Phase: Write Failing Tests

Before implementing any feature, write tests that define the expected behavior.

```gdscript
# Example: test_motion_input.gd
extends GutTest

func test_pole_vault_motion_detection():
    var motion_detector = MotionInputDetector.new()
    var input_sequence = [Vector2.DOWN, Vector2(1, 1), Vector2.RIGHT]
    
    var result = motion_detector.detect_pattern(input_sequence)
    
    assert_eq(result, "pole_vault", "Down-DownForward-Forward should trigger pole vault")

func test_motion_input_tolerance():
    var motion_detector = MotionInputDetector.new()
    # Slightly imprecise input (within tolerance)
    var input_sequence = [Vector2(0, 1), Vector2(0.8, 0.8), Vector2(0.9, 0)]
    
    var result = motion_detector.detect_pattern(input_sequence)
    
    assert_eq(result, "pole_vault", "Imprecise input within tolerance should still work")

func test_motion_input_timing():
    var motion_detector = MotionInputDetector.new()
    motion_detector.max_pattern_time = 1.0
    
    # Simulate inputs over time
    motion_detector.add_input(Vector2.DOWN, 0.0)
    motion_detector.add_input(Vector2(1, 1), 0.3)
    motion_detector.add_input(Vector2.RIGHT, 0.6)
    
    var result = motion_detector.check_for_patterns()
    
    assert_eq(result, "pole_vault", "Inputs within time window should register")
```

### 2. Green Phase: Implement Minimum Code

Write just enough code to make the tests pass.

```gdscript
# MotionInputDetector.gd - minimal implementation
class_name MotionInputDetector

var max_pattern_time: float = 0.5
var input_tolerance: float = 0.3

var input_sequence: Array = []
var pattern_detected: String = ""

func detect_pattern(inputs: Array) -> String:
    input_sequence = inputs
    _check_for_pole_vault()
    return pattern_detected

func _check_for_pole_vault():
    if input_sequence.size() < 3:
        return

    if _is_tilted_down(input_sequence[0]) and
       _is_tilted_down(input_sequence[1], true) and
       _is_tilted_right(input_sequence[2]):
        pattern_detected = "pole_vault"

func _is_tilted_down(input_vec: Vector2, strict: bool = false) -> bool:
    return (strict ? input_vec.y < -0.7 : input_vec.y > 0.7) and abs(input_vec.x) < 0.3

func _is_tilted_right(input_vec: Vector2) -> bool:
    return input_vec.x > 0.7 and abs(input_vec.y) < 0.3
```

### 3. Refactor Phase: Improve Code Quality

Enhance the implementation while maintaining test coverage.

```gdscript
# Improved MotionInputDetector.gd
class_name MotionInputDetector

@export var max_pattern_time: float = 0.5
@export var input_tolerance: float = 0.3

var input_sequence: Array = []
var pattern_detected: String = ""

func detect_pattern(inputs: Array) -> String:
    input_sequence = inputs
    _check_for_pole_vault()
    return pattern_detected

func _check_for_pole_vault():
    if input_sequence.size() < 3:
        return

    if _is_tilted_down(input_sequence[0]) and
       _is_tilted_down(input_sequence[1], true) and
       _is_tilted_right(input_sequence[2]):
        pattern_detected = "pole_vault"
    else:
        pattern_detected = ""

func _is_tilted_down(input_vec: Vector2, strict: bool = false) -> bool:
    return (strict ? input_vec.y < -0.7 : input_vec.y > 0.7) and abs(input_vec.x) < 0.3

func _is_tilted_right(input_vec: Vector2) -> bool:
    return input_vec.x > 0.7 and abs(input_vec.y) < 0.3
```

## Core System Test Suites

### Input System Tests

```gdscript
# test_motion_input.gd
extends GutTest

var motion_detector: MotionInputDetector

func before_each():
    motion_detector = MotionInputDetector.new()

func test_pole_vault_motion_detection():
    var input_sequence = [Vector2.DOWN, Vector2(1, 1), Vector2.RIGHT]
    
    var result = motion_detector.detect_pattern(input_sequence)
    
    assert_eq(result, "pole_vault", "Down-DownForward-Forward should trigger pole vault")

func test_motion_input_tolerance():
    # Slightly imprecise input (within tolerance)
    var input_sequence = [Vector2(0, 1), Vector2(0.8, 0.8), Vector2(0.9, 0)]
    
    var result = motion_detector.detect_pattern(input_sequence)
    
    assert_eq(result, "pole_vault", "Imprecise input within tolerance should still work")

func test_motion_input_timing():
    motion_detector.max_pattern_time = 1.0
    
    # Simulate inputs over time
    motion_detector.add_input(Vector2.DOWN, 0.0)
    motion_detector.add_input(Vector2(1, 1), 0.3)
    motion_detector.add_input(Vector2.RIGHT, 0.6)
    
    var result = motion_detector.check_for_patterns()
    
    assert_eq(result, "pole_vault", "Inputs within time window should register")
```

### Move System Tests

```gdscript
# test_move_system.gd
extends GutTest

var move_system: MoveSystem
var character: CharacterBody2D

func before_each():
    move_system = MoveSystem.new()
    character = CharacterBody2D.new()
    move_system.character = character

func test_basic_movement():
    move_system.move(Vector2.RIGHT)

    assert_eq(character.position.x, 10, "Character should move right")

func test_diagonal_movement():
    move_system.move(Vector2(1, 1))

    assert_eq(character.position, Vector2(10, 10), "Character should move diagonally")

func test_movement_restriction():
    character.position = Vector2(0, 0)
    move_system.move(Vector2.LEFT)

    assert_eq(character.position, Vector2(0, 0), "Character should not move through walls")
```

### Player Controller Tests

```gdscript
# test_player_controller.gd
extends GutTest

var player_controller: PlayerController
var mock_input: MockInput

func before_each():
    player_controller = PlayerController.new()
    mock_input = MockInput.new()
    player_controller.set_input_source(mock_input)

func test_player_moves_with_input():
    mock_input.set_stick_input(Vector2(1, 0))

    player_controller.update(0.016)  # 60fps delta

    assert_eq(player_controller.character.position.x, 1, "Player should move with input")

func test_player_attacks_with_button():
    mock_input.set_button_pressed("attack", true)

    player_controller.update(0.016)

    assert_true(player_controller.is_attacking, "Player should perform attack")

func test_player_cannot_move_and_attack():
    mock_input.set_stick_input(Vector2(1, 0))
    mock_input.set_button_pressed("attack", true)

    player_controller.update(0.016)

    assert_eq(player_controller.character.position.x, 0, "Player should not move while attacking")
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

### Room Progression Tests

```gdscript
# test_room_progression.gd
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

### Cutscene System Tests

```gdscript
# test_cutscene_system.gd
extends GutTest

var cutscene_manager: CutsceneManager
var player: Player

func before_each():
    cutscene_manager = CutsceneManager.new()
    player = Player.new()

func test_cutscene_triggers_on_room_enter():
    var room = Room.new()
    room.set_cutscene("tutorial_cutscene")

    cutscene_manager.start_cutscene(room)

    assert_true(cutscene_manager.is_playing, "Cutscene should start when entering room")

func test_cutscene_skippable():
    var room = Room.new()
    room.set_cutscene("long_cutscene")

    cutscene_manager.start_cutscene(room)
    cutscene_manager.skip_cutscene()

    assert_false(cutscene_manager.is_playing, "Cutscene should be skippable")
```

### Training Room Tests

```gdscript
# test_training_rooms.gd
extends GutTest

var training_room: TrainingRoom
var player: Player

func before_each():
    training_room = TrainingRoom.new()
    player = Player.new()
    training_room.add_player(player)

func test_basic_attack_training():
    player.set_input_sequence(["attack", "wait", "attack"])

    training_room.start_training()

    assert_true(player.has_completed_training, "Player should complete basic attack training")

func test_advanced_movement_training():
    player.set_input_sequence(["move_right", "jump", "move_left", "crouch"])

    training_room.start_training()

    assert_true(player.has_completed_training, "Player should complete advanced movement training")
```

## Performance Testing

### Animation Performance Tests

```gdscript
# test_animation_performance.gd
extends GutTest

func test_idle_animation_performance():
    var player = Player.new()
    player.play_idle_animation()

    var start_time = OS.get_ticks_msec()
    for i in range(1000):
        player.update_animation(0.016)
    var end_time = OS.get_ticks_msec()

    var duration = end_time - start_time
    assert_lt(duration, 16, "Idle animation should be performant")

func test_attack_animation_performance():
    var player = Player.new()
    player.play_attack_animation()

    var start_time = OS.get_ticks_msec()
    for i in range(1000):
        player.update_animation(0.016)
    var end_time = OS.get_ticks_msec()

    var duration = end_time - start_time
    assert_lt(duration, 16, "Attack animation should be performant")
```

### Memory Usage Tests

```gdscript
# test_memory_usage.gd
extends GutTest

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

### Motion Tolerance Tests

```gdscript
# test_motion_tolerance.gd
extends GutTest

func test_pole_vault_motion_detection_with_tolerance():
    var motion_detector = MotionInputDetector.new()
    motion_detector.input_tolerance = 0.2
    var input_sequence = [Vector2.DOWN, Vector2(0.9, 0.9), Vector2.RIGHT]
    
    var result = motion_detector.detect_pattern(input_sequence)
    
    assert_eq(result, "pole_vault", "Down-DownForward-Forward with tolerance should trigger pole vault")

func test_excessive_input_tolerance():
    var motion_detector = MotionInputDetector.new()
    motion_detector.input_tolerance = 0.1
    var input_sequence = [Vector2.DOWN, Vector2(0.95, 0.95), Vector2.RIGHT]
    
    var result = motion_detector.detect_pattern(input_sequence)
    
    assert_ne(result, "pole_vault", "Excessive input should not trigger pole vault")
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
