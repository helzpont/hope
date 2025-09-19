# HOPE - Technical Architecture

## Project Overview

HOPE is built using Godot 4.x with a focus on arcade-style movement, fighting game-inspired motion inputs, and stick-only controls. This document outlines the technical architecture, system design, and implementation patterns used throughout the project.

## System Architecture

### High-Level Component Diagram

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Input Layer   │    │ Movement Layer  │    │ Presentation    │
│                 │    │                 │    │     Layer       │
│ • InputManager  │───▶│ • MotionDetector│───▶│ • AudioManager  │
│ • Controller    │    │ • MoveSystem    │    │ • AnimationSys  │
│   Mapping       │    │ • Arcade Physics│    │ • UI Systems    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Game Logic    │    │   AI Systems    │    │  Story Layer    │
│                 │    │                 │    │                 │
│ • GameManager   │    │ • EnemyAI       │    │ • CutsceneManager│
│ • RoomManager   │    │ • Simple        │    │ • TrainingRooms │
│ • ProgressionMgr│    │   Behaviors     │    │ • LinearStory   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Core Systems

### 1. Motion Input System

#### MotionInputDetector Class

```gdscript
# scripts/systems/MotionInputDetector.gd
extends Node
class_name MotionInputDetector

signal motion_detected(motion_name: String)

@export var motion_buffer_time: float = 0.5
@export var input_tolerance_degrees: float = 22.5
@export var minimum_input_magnitude: float = 0.3

var motion_buffer: Array[MotionInput] = []
var known_patterns: Dictionary = {}

class MotionInput:
    var direction: Vector2
    var timestamp: float

    func _init(dir: Vector2, time: float):
        direction = dir
        timestamp = time

func _ready():
    _setup_motion_patterns()

func _setup_motion_patterns():
    # Define motion patterns for special moves
    known_patterns["pole_vault"] = [Vector2.DOWN, Vector2(1, 1), Vector2.RIGHT]
    known_patterns["spinning_swipe"] = [Vector2.RIGHT, Vector2.DOWN, Vector2(1, 1)]
    known_patterns["wall_slide"] = [Vector2.LEFT, Vector2(-1, 1), Vector2.DOWN]
    known_patterns["pole_plant"] = [Vector2.DOWN, Vector2.UP]
    known_patterns["sweep_attack"] = [Vector2(1, 1), Vector2.RIGHT, Vector2(1, -1)]

func add_input(direction: Vector2):
    if direction.length() < minimum_input_magnitude:
        return

    var current_time = Time.get_time_dict_from_system()
    motion_buffer.append(MotionInput.new(direction.normalized(), current_time))

    _clean_old_inputs()
    _check_for_patterns()

func _check_for_patterns():
    for pattern_name in known_patterns:
        if _matches_pattern(known_patterns[pattern_name]):
            motion_detected.emit(pattern_name)
            motion_buffer.clear()
            break
```

#### Dual-Circle Input System

### 1. Refined Dual-Circle Input System

#### DualCircleInputDetector Class

```gdscript
# scripts/systems/DualCircleInputDetector.gd
extends Node
class_name DualCircleInputDetector

signal circle_changed(new_circle: InputCircle, previous_circle: InputCircle)
signal complexity_level_changed(level: String)

enum InputCircle {
    NONE,
    INNER,    # <90% magnitude - complex moves requiring skill
    OUTER     # >=90% magnitude - simple moves requiring force
}

@export var circle_threshold: float = 0.9  # 90% magnitude threshold
@export var hysteresis_buffer: float = 0.05  # 5% buffer to prevent flickering
@export var dead_zone: float = 0.1

var current_circle: InputCircle = InputCircle.NONE
var previous_circle: InputCircle = InputCircle.NONE
var circle_history: Array[InputCircle] = []

func process_input(stick_input: Vector2) -> Dictionary:
    var magnitude = stick_input.length()
    var direction = stick_input.normalized() if magnitude > dead_zone else Vector2.ZERO
    
    var detected_circle = _determine_circle_with_hysteresis(magnitude)
    var complexity = _get_complexity_level(detected_circle)
    var is_transition = _check_transition(detected_circle)
    
    if is_transition:
        _handle_circle_transition(current_circle, detected_circle)
    
    _update_circle_state(detected_circle)
    
    return {
        "circle": current_circle,
        "direction": direction,
        "magnitude": magnitude,
        "complexity_level": complexity,
        "is_transition": is_transition,
        "in_transition_zone": _is_in_transition_zone(magnitude)
    }

func _determine_circle_with_hysteresis(magnitude: float) -> InputCircle:
    if magnitude < dead_zone:
        return InputCircle.NONE
    
    # Apply hysteresis to prevent flickering during complex motions
    match current_circle:
        InputCircle.OUTER:
            # Once in outer circle, need to drop below 85% to return to inner
            if magnitude < (circle_threshold - hysteresis_buffer):
                return InputCircle.INNER
            else:
                return InputCircle.OUTER
        InputCircle.INNER:
            # From inner circle, need to exceed 90% to reach outer
            if magnitude >= circle_threshold:
                return InputCircle.OUTER
            else:
                return InputCircle.INNER
        _:
            # Initial detection without hysteresis
            if magnitude >= circle_threshold:
                return InputCircle.OUTER
            else:
                return InputCircle.INNER

func _is_in_transition_zone(magnitude: float) -> bool:
    return magnitude >= (circle_threshold - hysteresis_buffer) and magnitude <= (circle_threshold + hysteresis_buffer)

func _get_complexity_level(circle: InputCircle) -> String:
    match circle:
        InputCircle.INNER:
            return "complex"    # Requires precision and skill
        InputCircle.OUTER:
            return "simple"     # Basic directional actions
        _:
            return "none"
```

#### MotionPatternDetector Class

```gdscript
# scripts/systems/MotionPatternDetector.gd
extends Node
class_name MotionPatternDetector

signal pattern_detected(pattern_name: String)

# Simplified, tunable parameters (no over-engineering)
@export var pattern_timeout: float = 1.0  # Tunable through playtesting
@export var directional_tolerance: float = 30.0  # Generous tolerance
@export var max_move_count: int = 8  # Limited move set for focus

var motion_buffer: Array[MotionInput] = []
var core_patterns: Dictionary = {}

func _ready():
    _setup_core_move_set()

func _setup_core_move_set():
    # Simplified core move set (6-8 moves maximum)
    core_patterns["walk"] = {
        "type": "hold",
        "circle": DualCircleInputDetector.InputCircle.INNER,
        "complexity": "basic"
    }
    
    core_patterns["sprint"] = {
        "type": "hold", 
        "circle": DualCircleInputDetector.InputCircle.OUTER,
        "complexity": "basic"
    }
    
    core_patterns["pole_vault"] = {
        "type": "sequence",
        "pattern": ["down", "down_forward", "forward"],
        "circle": DualCircleInputDetector.InputCircle.INNER,
        "complexity": "intermediate"
    }
    
    core_patterns["spinning_swipe"] = {
        "type": "sequence",
        "pattern": ["forward", "down", "down_forward"],
        "circle": DualCircleInputDetector.InputCircle.INNER,
        "complexity": "advanced"
    }
    
    # Removed overly complex patterns (270° rotations, etc.)
    # Focus on 6 core moves that feel good to execute
```

#### InputManager Class (No Stick Clicks)

```gdscript
# scripts/systems/InputManager.gd
extends Node
class_name InputManager

signal movement_input_changed(movement: Vector2)
signal camera_input_changed(camera: Vector2)
signal dual_circle_input_detected(input_data: Dictionary)

@export var left_stick_dead_zone: float = 0.1
@export var right_stick_dead_zone: float = 0.15

var current_controller: int = -1
var dual_circle_detector: DualCircleInputDetector
var motion_pattern_detector: MotionPatternDetector

# Explicitly disable stick clicks
var processes_stick_clicks: bool = false
var left_stick_click_enabled: bool = false
var right_stick_click_enabled: bool = false

func _ready():
    dual_circle_detector = DualCircleInputDetector.new()
    motion_pattern_detector = MotionPatternDetector.new()
    add_child(dual_circle_detector)
    add_child(motion_pattern_detector)

    _detect_controllers()
    _setup_input_mapping()

func _input(event: InputEvent):
    if event is InputEventJoypadMotion:
        _handle_stick_motion(event)
    # Explicitly ignore button events including stick clicks

func _handle_stick_motion(event: InputEventJoypadMotion):
    match event.axis:
        JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y:
            _process_left_stick_input()
        JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y:
            _process_right_stick_camera()

func _process_left_stick_input():
    var raw_input = Vector2(
        Input.get_joy_axis(current_controller, JOY_AXIS_LEFT_X),
        Input.get_joy_axis(current_controller, JOY_AXIS_LEFT_Y)
    )

    var input_data = dual_circle_detector.process_input(raw_input)
    dual_circle_input_detected.emit(input_data)

    # Send to motion detector for pattern recognition
    if input_data.circle != DualCircleInputDetector.InputCircle.NONE:
        motion_pattern_detector.add_input(
            input_data.direction,
            input_data.magnitude,
            input_data.circle
        )

func _process_right_stick_camera():
    # Camera control only - no action processing
    var camera_input = Vector2(
        Input.get_joy_axis(current_controller, JOY_AXIS_RIGHT_X),
        Input.get_joy_axis(current_controller, JOY_AXIS_RIGHT_Y)
    )

    if camera_input.length() > right_stick_dead_zone:
        camera_input_changed.emit(camera_input)
```

````markdown
### 2. Physics System

#### Balance System Architecture

```gdscript
# scripts/player/BalanceSystem.gd
extends Node
class_name BalanceSystem

signal balance_state_changed(state: BalanceState)
signal balance_lost()
signal balance_recovered()

enum BalanceState {
    STABLE,
    UNSTABLE,
    FALLING
}

@export var stability_threshold: float = 0.3
@export var falling_threshold: float = 0.7
@export var recovery_time: float = 0.5

var current_balance: float = 0.0
var current_state: BalanceState = BalanceState.STABLE
var recovery_timer: float = 0.0

# Balance factors
var pole_angle_factor: float = 0.0
var velocity_factor: float = 0.0
var external_force_factor: float = 0.0

func _ready():
    set_physics_process(true)

func _physics_process(delta: float):
    _update_balance_calculation(delta)
    _update_balance_state()
    _handle_recovery_timer(delta)

func _update_balance_calculation(delta: float):
    pole_angle_factor = _calculate_pole_angle_factor()
    velocity_factor = _calculate_velocity_factor()
    external_force_factor = _calculate_external_force_factor()

    # Weighted average of factors
    current_balance = (
        pole_angle_factor * 0.5 +
        velocity_factor * 0.3 +
        external_force_factor * 0.2
    )

func _calculate_pole_angle_factor() -> float:
    var pole = get_parent().get_node("Pole") as PolePhysics
    if not pole:
        return 0.0

    var angle_degrees = abs(rad_to_deg(pole.rotation))
    return clamp(angle_degrees / 45.0, 0.0, 1.0)  # 45° = max stable angle

func _calculate_velocity_factor() -> float:
    var player = get_parent() as CharacterBody2D
    if not player:
        return 0.0

    var speed = player.velocity.length()
    return clamp(speed / 200.0, 0.0, 1.0)  # 200 = max stable speed

func _update_balance_state():
    var new_state: BalanceState

    if current_balance < stability_threshold:
        new_state = BalanceState.STABLE
    elif current_balance < falling_threshold:
        new_state = BalanceState.UNSTABLE
    else:
        new_state = BalanceState.FALLING

    if new_state != current_state:
        current_state = new_state
        balance_state_changed.emit(current_state)

        if current_state == BalanceState.FALLING:
            balance_lost.emit()
```

#### Pole Physics Implementation

```gdscript
# scripts/player/PolePhysics.gd
extends RigidBody2D
class_name PolePhysics

@export var pole_length: float = 150.0
@export var pole_mass: float = 2.0
@export var damping_factor: float = 0.95

var attached_character: CharacterBody2D
var attachment_point: Vector2

func _ready():
    set_gravity_scale(1.0)
    set_mass(pole_mass)
    _setup_collision_shape()

func _setup_collision_shape():
    var shape = CapsuleShape2D.new()
    shape.height = pole_length
    shape.radius = 5.0

    var collision = CollisionShape2D.new()
    collision.shape = shape
    add_child(collision)

func attach_to_character(character: CharacterBody2D):
    attached_character = character
    attachment_point = Vector2(0, -20)  # Slightly above character center

    # Create joint connection
    var joint = PinJoint2D.new()
    joint.node_a = character.get_path()
    joint.node_b = get_path()
    joint.position = attachment_point
    character.add_child(joint)

func _integrate_forces(state: PhysicsDirectBodyState2D):
    if not attached_character:
        return

    # Apply character movement influence
    var character_velocity = attached_character.velocity
    var influence_force = character_velocity * 0.1
    state.apply_central_force(influence_force)

    # Apply damping
    state.angular_velocity *= damping_factor
    state.linear_velocity *= damping_factor

    # Maintain attachment
    _maintain_attachment(state)

func _maintain_attachment(state: PhysicsDirectBodyState2D):
    var target_position = attached_character.global_position + attachment_point
    var current_position = state.transform.origin

    var correction_force = (target_position - current_position) * 100.0
    state.apply_central_force(correction_force)
```

### 3. Scene Architecture

#### Main Scene Structure

```
Main.tscn
├── GameManager (Node)
│   ├── InputManager (Node)
│   ├── AudioManager (Node)
│   └── SaveSystem (Node)
├── UI (CanvasLayer)
│   ├── BalanceIndicator (Control)
│   ├── InteractionPrompts (Control)
│   └── PauseMenu (Control)
├── CameraRig (Node2D)
│   └── Camera2D
└── RoomContainer (Node2D)
    └── [Current Room Scene]
```

#### Room Scene Template

```
Room.tscn
├── Environment (Node2D)
│   ├── StaticGeometry (StaticBody2D)
│   ├── MovingPlatforms (Node2D)
│   └── Hazards (Node2D)
├── Player (CharacterBody2D)
│   ├── Sprite2D
│   ├── CollisionShape2D
│   ├── BalanceSystem (Node)
│   └── Pole (PolePhysics)
├── Enemies (Node2D)
│   └── [Enemy instances]
├── Interactive (Node2D)
│   ├── Switches (Node2D)
│   └── Doors (Node2D)
└── RoomLogic (Node)
    ├── SpawnPoint (Marker2D)
    ├── ExitTrigger (Area2D)
    └── Checkpoints (Node2D)
```

### 4. AI System Architecture

#### Base Enemy AI Framework

```gdscript
# scripts/enemies/BaseEnemyAI.gd
extends CharacterBody2D
class_name BaseEnemyAI

signal player_detected(player: Node2D)
signal player_lost()
signal state_changed(new_state: String)

enum AIState {
    IDLE,
    PATROL,
    ALERT,
    CHASE,
    ATTACK,
    STUNNED
}

@export var detection_range: float = 200.0
@export var movement_speed: float = 80.0
@export var state_machine: StateMachine

var current_state: AIState = AIState.IDLE
var player_reference: CharacterBody2D
var last_known_player_position: Vector2

func _ready():
    _setup_state_machine()
    _setup_detection_area()

func _physics_process(delta: float):
    _update_ai_state(delta)
    _execute_current_behavior(delta)
    move_and_slide()

func _setup_state_machine():
    state_machine = StateMachine.new()
    state_machine.add_state("idle", _idle_behavior)
    state_machine.add_state("patrol", _patrol_behavior)
    state_machine.add_state("alert", _alert_behavior)
    state_machine.set_initial_state("idle")

func _setup_detection_area():
    var detection_area = Area2D.new()
    var detection_shape = CircleShape2D.new()
    detection_shape.radius = detection_range

    var collision = CollisionShape2D.new()
    collision.shape = detection_shape
    detection_area.add_child(collision)
    add_child(detection_area)

    detection_area.body_entered.connect(_on_player_detected)
    detection_area.body_exited.connect(_on_player_lost)

# Virtual methods for subclasses to override
func _idle_behavior(delta: float):
    pass

func _patrol_behavior(delta: float):
    pass

func _alert_behavior(delta: float):
    pass
```

#### Specific Enemy Implementations

```gdscript
# scripts/enemies/PatrolBot.gd
extends BaseEnemyAI
class_name PatrolBot

@export var patrol_points: Array[Vector2] = []
@export var wait_time: float = 2.0

var current_patrol_index: int = 0
var wait_timer: float = 0.0

func _patrol_behavior(delta: float):
    if patrol_points.is_empty():
        return

    var target = patrol_points[current_patrol_index]
    var direction = (target - global_position).normalized()

    velocity = direction * movement_speed

    # Check if reached patrol point
    if global_position.distance_to(target) < 10.0:
        _handle_patrol_point_reached()

func _handle_patrol_point_reached():
    wait_timer += get_physics_process_delta_time()

    if wait_timer >= wait_time:
        current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
        wait_timer = 0.0
```

### 5. Audio System

#### Dynamic Audio Manager

```gdscript
# scripts/systems/AudioManager.gd
extends Node
class_name AudioManager

@export var master_volume: float = 1.0
@export var sfx_volume: float = 1.0
@export var music_volume: float = 0.7

var audio_pools: Dictionary = {}
var current_music: AudioStreamPlayer
var balance_audio: AudioStreamPlayer

func _ready():
    _setup_audio_pools()
    _setup_balance_audio()

func _setup_audio_pools():
    # Create pools for frequently used sounds
    audio_pools["footsteps"] = _create_audio_pool("footsteps", 4)
    audio_pools["pole_contact"] = _create_audio_pool("pole_contact", 8)
    audio_pools["enemy_alert"] = _create_audio_pool("enemy_alert", 3)

func _create_audio_pool(sound_name: String, pool_size: int) -> Array[AudioStreamPlayer]:
    var pool: Array[AudioStreamPlayer] = []

    for i in pool_size:
        var player = AudioStreamPlayer.new()
        player.stream = load("res://audio/sfx/" + sound_name + ".ogg")
        add_child(player)
        pool.append(player)

    return pool

func play_sound(sound_name: String, pitch_variation: float = 0.0):
    if not audio_pools.has(sound_name):
        return

    var pool = audio_pools[sound_name]
    var available_player = _get_available_player(pool)

    if available_player:
        available_player.pitch_scale = 1.0 + pitch_variation
        available_player.volume_db = linear_to_db(sfx_volume)
        available_player.play()

func update_balance_audio(balance_state: float):
    if not balance_audio:
        return

    # Adjust audio based on balance state
    var tension_level = clamp(balance_state, 0.0, 1.0)
    balance_audio.pitch_scale = 1.0 + (tension_level * 0.5)
    balance_audio.volume_db = linear_to_db(tension_level * 0.3)
```

### 6. Save System

#### Persistent Data Management

```gdscript
# scripts/systems/SaveSystem.gd
extends Node
class_name SaveSystem

const SAVE_FILE_PATH = "user://save_game.dat"
const SETTINGS_FILE_PATH = "user://settings.cfg"

var current_save_data: Dictionary = {}
var game_settings: ConfigFile

func _ready():
    game_settings = ConfigFile.new()
    _load_settings()

func save_game(data: Dictionary):
    current_save_data = data
    current_save_data["timestamp"] = Time.get_unix_time_from_system()
    current_save_data["version"] = ProjectSettings.get_setting("application/config/version")

    var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
    if file:
        var json_string = JSON.stringify(current_save_data)
        file.store_string(json_string)
        file.close()

func load_game() -> Dictionary:
    if not FileAccess.file_exists(SAVE_FILE_PATH):
        return _get_default_save_data()

    var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
    if not file:
        return _get_default_save_data()

    var json_string = file.get_as_text()
    file.close()

    var json = JSON.new()
    var parse_result = json.parse(json_string)

    if parse_result != OK:
        return _get_default_save_data()

    return json.data

func _get_default_save_data() -> Dictionary:
    return {
        "current_room": 1,
        "completed_rooms": [],
        "total_playtime": 0.0,
        "settings": {
            "master_volume": 1.0,
            "sfx_volume": 1.0,
            "music_volume": 0.7,
            "left_stick_dead_zone": 0.1,
            "right_stick_dead_zone": 0.15
        }
    }
```

## Performance Optimization

### Physics Optimization

- Use Godot's built-in physics for pole simulation
- Implement custom balance calculations for performance
- Pool frequently created objects (particles, projectiles)
- Optimize collision detection with appropriate collision layers

### Memory Management

- Preload frequently used scenes and resources
- Use object pooling for temporary objects
- Implement proper cleanup in scene transitions
- Monitor memory usage with built-in profiler

### Rendering Optimization

- Use appropriate texture sizes for target resolution
- Implement level-of-detail for background elements
- Optimize particle systems for performance
- Use efficient shaders for visual effects

## Platform Considerations

### Controller Support

- Test with multiple controller types (Xbox, PlayStation, generic)
- Implement controller hotswapping
- Provide dead zone customization
- Support controller vibration for feedback

### Accessibility Features

- High contrast visual options
- Colorblind-friendly color schemes
- Audio cues for visual elements
- Customizable input sensitivity

### Performance Targets

- 60fps on minimum spec hardware
- Sub-3-second room loading times
- Stable memory usage over extended play
- Responsive input with minimal latency

## Development Tools

### Debug Visualization

- Balance state indicators
- Physics force visualization
- AI state display
- Performance metrics overlay

### Level Editor Integration

- Custom tools for room creation
- Automated testing for room completion
- Visual scripting for simple interactions
- Asset validation and optimization

This architecture provides a solid foundation for developing HOPE while maintaining code quality, performance, and extensibility. Each system is designed to be modular and testable, supporting the test-driven development approach outlined in the project documentation.
````
