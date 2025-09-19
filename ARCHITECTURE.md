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

#### InputManager Class
```gdscript
# scripts/systems/InputManager.gd
extends Node
class_name InputManager

signal movement_input_changed(movement: Vector2)
signal camera_input_changed(camera: Vector2)
signal interaction_triggered()

@export var left_stick_dead_zone: float = 0.1
@export var right_stick_dead_zone: float = 0.15
@export var stick_sensitivity: float = 1.0

var current_controller: int = -1
var motion_detector: MotionInputDetector
var input_buffer: Array[InputEvent] = []

func _ready():
    _detect_controllers()
    _setup_input_mapping()

func _input(event: InputEvent):
    if event is InputEventJoypadMotion:
        _handle_stick_input(event)
    elif event is InputEventJoypadButton:
        _handle_button_input(event)

func _handle_stick_input(event: InputEventJoypadMotion):
    match event.axis:
        JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y:
            _process_movement_input()
        JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y:
            _process_camera_input()

func get_movement_input() -> Vector2:
    var raw_input = Vector2(
        Input.get_joy_axis(current_controller, JOY_AXIS_LEFT_X),
        Input.get_joy_axis(current_controller, JOY_AXIS_LEFT_Y)
    )
    return _apply_dead_zone(raw_input, left_stick_dead_zone)

func get_camera_input() -> Vector2:
    var raw_input = Vector2(
        Input.get_joy_axis(current_controller, JOY_AXIS_RIGHT_X),
        Input.get_joy_axis(current_controller, JOY_AXIS_RIGHT_Y)
    )
    return _apply_dead_zone(raw_input, right_stick_dead_zone)

func _apply_dead_zone(input: Vector2, dead_zone: float) -> Vector2:
    if input.length() < dead_zone:
        return Vector2.ZERO

    # Scale input to remove dead zone
    var scaled_magnitude = (input.length() - dead_zone) / (1.0 - dead_zone)
    return input.normalized() * scaled_magnitude * stick_sensitivity
```

#### Controller Compatibility Layer

```gdscript
# scripts/systems/ControllerMapper.gd
extends Resource
class_name ControllerMapper

enum ControllerType {
    XBOX,
    PLAYSTATION,
    NINTENDO_SWITCH,
    GENERIC
}

var controller_mappings: Dictionary = {
    ControllerType.XBOX: {
        "left_stick_x": JOY_AXIS_LEFT_X,
        "left_stick_y": JOY_AXIS_LEFT_Y,
        "right_stick_x": JOY_AXIS_RIGHT_X,
        "right_stick_y": JOY_AXIS_RIGHT_Y,
        "right_stick_click": JOY_BUTTON_RIGHT_STICK
    },
    ControllerType.PLAYSTATION: {
        "left_stick_x": JOY_AXIS_LEFT_X,
        "left_stick_y": JOY_AXIS_LEFT_Y,
        "right_stick_x": JOY_AXIS_RIGHT_X,
        "right_stick_y": JOY_AXIS_RIGHT_Y,
        "right_stick_click": JOY_BUTTON_RIGHT_STICK
    }
}

func detect_controller_type(device_id: int) -> ControllerType:
    var device_name = Input.get_joy_name(device_id).to_lower()

    if "xbox" in device_name or "microsoft" in device_name:
        return ControllerType.XBOX
    elif "playstation" in device_name or "sony" in device_name:
        return ControllerType.PLAYSTATION
    elif "nintendo" in device_name or "switch" in device_name:
        return ControllerType.NINTENDO_SWITCH
    else:
        return ControllerType.GENERIC
```

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
