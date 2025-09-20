# HOPE - Game Design Document

## Core Mechanics Specification

### Arcade Movement System

#### Movement Philosophy

- **Responsive Controls**: Immediate character response to input
- **Forgiving Gameplay**: Generous timing windows and input buffering
- **Visual Polish**: Animations suggest mechanical precision without simulation complexity
- **Predictable Behavior**: Consistent movement speeds and distances for reliable platforming

#### Basic Movement Properties

- **Speed**: Constant 120 pixels/second in all directions
- **Acceleration**: Instant start/stop for responsive feel
- **Animation**: Smooth interpolation between movement states
- **8-Directional**: Full directional movement with diagonal support

### Motion Input System

#### Input Detection

```
Motion Buffer: 0.5 second window for pattern completion
Input Tolerance: ±22.5° angle variance for directional inputs
Minimum Hold Time: 0.1 seconds for directional registration
Maximum Pattern Time: 1.0 seconds from first to last input
```

#### Control Mapping

- **Left Stick**: Motion input and basic movement
  - **Neutral**: No movement, ready for motion input
  - **Directional Hold**: Continuous movement in direction
  - **Motion Patterns**: Sequence of directions for special moves
- **Right Stick**: Camera and interaction
  - **Horizontal**: Camera pan (-45° to +45°)
  - **Vertical**: Camera zoom (0.8x to 1.5x)
  - **Click**: Interact with nearby objects

### Dual-Circle Input System

#### Input Philosophy

- **Inverted Complexity**: Inner circle requires more skill than outer circle
- **Sequential Input Only**: No simultaneous inputs - all actions from left stick
- **Magnitude-Based Actions**: Stick pressure determines available action set
- **Mechanical Intuition**: Precise movements (inner circle) are harder than forceful ones (outer circle)

#### Circle Definitions

```
Inner Circle: 0% to <90% stick magnitude
- Complex motion patterns requiring precision
- Advanced pole techniques
- Skill-demanding movements

Transition Zone: 85-95% stick magnitude
- Hysteresis buffer to prevent flickering during complex motions
- Maintains current circle state until clear threshold crossed
- Essential for smooth execution of multi-directional patterns

Outer Circle: >=90% stick magnitude (with hysteresis)
- Simple directional actions
- Basic movements and holds
- Force-based actions requiring commitment
- Natural max-magnitude inputs from experienced players

Dead Zone: 0% to 10% magnitude (no input registered)
Right Stick: Camera control only (no clicks allowed)
```

#### Input Detection System

```
Motion Buffer: 0.8 second window for pattern completion
Circle Detection: 90% magnitude threshold with 5% hysteresis buffer
Directional Tolerance: ±22.5° angle variance
Minimum Hold Time: 0.15 seconds for circle registration
Pattern Timeout: 1.2 seconds maximum for complex sequences
No Simultaneous Inputs: Only left stick processed for movement/actions
Hysteresis Logic: Once in outer circle, requires <85% to return to inner circle
```

### Control Mapping Specification

#### Left Stick Only System

- **Inner Circle (<90%)**: Complex patterns and precision movements

  - **Motion Patterns**: Multi-directional sequences for advanced moves
  - **High Skill**: Actions requiring precise timing and coordination
  - **Advanced Techniques**: Learned through progression

- **Outer Circle (>=90%)**: Simple actions and basic movement
  - **Directional Holds**: Basic movement and simple pole positions
  - **Force Actions**: Movements requiring commitment but not precision
  - **Beginner Friendly**: Accessible actions available from start

#### Right Stick (Camera Only)

- **Horizontal**: Camera pan (-45° to +45°)
- **Vertical**: Camera zoom (0.8x to 1.5x)
- **No Clicks**: Stick clicks are considered buttons and not allowed

### Move System Specification

#### Outer Circle Moves (>=90% magnitude - Simple Actions)

1. **Walk**: Hold direction - 120 pixels/second movement (adjustable), pole leans slightly
2. **Sprint**: Hold direction - 180 pixels/second movement (adjustable), pole leans forward
3. **Stop**: Hold up - Pole straightens, robot enters neutral position
4. **Crouch**: Hold down - Pole drops naturally, lower profile

#### Mixed Circle Moves (Outer → Inner Transitions)

1. **Stand Up**: Full outer circle rotation + full inner circle up
   - **Mechanical Logic**: Force to lift pole, then precision to balance
   - **Input**: Outer circle 360° + inner circle ↑
   - **Duration**: 1.2 seconds total animation

#### Inner Circle Moves (<90% magnitude - Complex Actions)

1. **Pole Vault**: Inner circle ↓↘→

   - **Mechanical Logic**: Precise pole placement and timing for vault
   - **Duration**: 1.0 seconds total animation
   - **Distance**: 200 pixels forward, 80 pixels height clearance
   - **Skill Level**: Intermediate

2. **Spinning Swipe**: Inner circle →↓↘ + 270° rotation

   - **Mechanical Logic**: Precise spinning motion with pole control
   - **Duration**: 1.2 seconds total animation
   - **Range**: 360° attack, 120-pixel radius
   - **Skill Level**: Advanced

3. **Wall Slide**: Inner circle ←↙↓ (near wall)

   - **Mechanical Logic**: Precise pole angle control against wall
   - **Duration**: Continuous until ground contact
   - **Speed**: 80 pixels/second descent
   - **Requirement**: Within 25 pixels of wall surface

4. **Sweep Attack**: Inner circle ↘→↗

   - **Mechanical Logic**: Precise low sweeping motion
   - **Duration**: 0.8 seconds total animation
   - **Range**: 180° arc, 150-pixel reach, ground level only
   - **Skill Level**: Advanced

5. **Pole Lean**: Inner circle partial rotation (45-180°)
   - **Mechanical Logic**: Precise pole positioning for switches/balance
   - **Duration**: Held position until input released
   - **Effect**: Activate distant switches, maintain balance on moving platforms
   - **Skill Level**: Intermediate

## Core Systems Design

### Save System

```
Auto-Save Triggers:
- Room completion
- Move learning (after cutscene)
- Settings changes

Save Data Structure:
- Current room number (1-20)
- Learned moves list
- Best completion times per room
- Total playtime
- Settings (audio, visual accessibility)

Technical Requirements:
- JSON format for human readability
- Corruption detection and recovery
- Settings persistence across sessions
- Progress backup to prevent loss
```

### Audio System Design

```
Dynamic Music Layers:
- Base ambient track (always playing)
- Tension layer (activates near enemies/hazards)
- Success stinger (move completion, room clear)
- Failure sound (fall, restart)

Spatial Audio:
- Enemy detection audio cues
- Environmental hazard warnings
- Directional feedback for off-screen elements

Accessibility Audio:
- Move execution confirmation sounds
- Circle transition audio feedback
- Distinct audio signatures for each enemy type
- Optional audio descriptions for visual elements
```

### Performance Targets

```
Frame Rate: 60fps minimum on target hardware
Resolution: 1920x1080 native, scalable to 1280x720
Memory Usage: <512MB RAM total
Loading Times: <2 seconds per room transition
Input Latency: <16ms from stick input to visual response

Optimization Priorities:
1. Input responsiveness (highest priority)
2. Smooth animations during moves
3. Consistent frame rate during complex scenes
4. Fast room transitions
```

### Tutorial and Onboarding System

```
Tutorial Progression:
Room 1: Basic movement (inner circle only)
Room 2: Camera controls and environmental interaction
Room 3: Outer circle introduction with simple moves
Room 4: First complex move (pole vault) with extensive guidance
Room 5: Move combination and timing practice

Onboarding Features:
- Visual input indicators showing current circle
- Move demonstration videos (skippable)
- Practice mode accessible from pause menu
- Hint system for struggling players (optional)
- Progress tracking with encouragement messages

Teaching Methodology:
- Show: Cutscene demonstrates new move
- Practice: Safe training room with targets/obstacles
- Apply: Real room requiring the new move
- Master: Later rooms combining multiple moves
```

### Accessibility Design (Non-Controller)

```
Visual Accessibility:
- High contrast mode for UI elements
- Colorblind-friendly palette (tested with simulators)
- Scalable UI text (100%, 125%, 150%)
- Clear visual distinction between interactive/decorative elements
- Motion reduction options for sensitive players

Audio Accessibility:
- Full subtitle support for all audio
- Visual indicators for audio cues (enemy alerts, hazards)
- Adjustable audio balance (music/SFX/voice)
- Audio descriptions for important visual events (optional)

Cognitive Accessibility:
- Clear, consistent visual language
- Generous timing windows for input patterns
- Optional simplified move set (fewer total moves)
- Progress indicators and clear objectives
- Pause-anywhere functionality
```

## Technical Simplifications

### Removed Over-Engineering

```
Eliminated Excessive Precision:
- Removed exact pixel measurements (now relative values)
- Simplified timing windows (determined through playtesting)
- Reduced complex input patterns (no 270° rotations)
- Streamlined move count (focus on 6-8 core moves)

Practical Approach:
- Values marked as "tunable" rather than fixed
- Emphasis on feel over mathematical precision
- Playtesting-driven parameter adjustment
- Iterative refinement based on player feedback
```
