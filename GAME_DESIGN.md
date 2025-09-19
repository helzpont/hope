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

Outer Circle: >=90% stick magnitude  
- Simple directional actions
- Basic movements and holds
- Force-based actions requiring commitment

Dead Zone: 0% to 10% magnitude (no input registered)
Right Stick: Camera control only (no clicks allowed)
```

#### Input Detection System
```
Motion Buffer: 0.8 second window for pattern completion
Circle Detection: Clear 90% magnitude threshold
Directional Tolerance: ±22.5° angle variance
Minimum Hold Time: 0.15 seconds for circle registration
Pattern Timeout: 1.2 seconds maximum for complex sequences
No Simultaneous Inputs: Only left stick processed for movement/actions
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
1. **Walk**: Hold direction - 120 pixels/second movement, pole leans slightly
2. **Sprint**: Hold direction - 180 pixels/second movement, pole leans forward
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
