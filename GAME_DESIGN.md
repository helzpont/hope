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

- **Mechanical Realism**: Input difficulty matches physical effort required
- **Magnitude-Based Actions**: Stick pressure determines action complexity
- **Intuitive Mapping**: Harder moves require more demanding inputs
- **Progressive Complexity**: Advanced techniques build on basic movements

#### Circle Definitions

```
Inner Circle: 0% to 70% stick magnitude
- Basic movements and low-effort actions
- Continuous directional input
- Simple pole positioning

Outer Circle: 70% to 97% stick magnitude  
- Complex motion patterns
- High-effort mechanical actions
- Advanced pole techniques
- Precision timing requirements

Dead Zone: 0% to 10% magnitude (no input registered)
Maximum Range: 97% magnitude (prevents accidental max input)
```

#### Input Detection System

```
Motion Buffer: 0.8 second window for pattern completion
Circle Transition Tolerance: ±5% magnitude variance
Directional Tolerance: ±22.5° angle variance
Minimum Hold Time: 0.15 seconds for circle registration
Pattern Timeout: 1.2 seconds maximum for complex sequences
```

### Control Mapping Specification

#### Left Stick Dual-Circle System

- **Inner Circle (0-70%)**: Basic movement and simple actions
  - **Directional Hold**: Continuous movement at base speed
  - **Simple Patterns**: Single-direction actions (crouch, reach)
  - **Low Effort**: Actions requiring minimal mechanical force

- **Outer Circle (70-97%)**: Advanced techniques and complex motions
  - **Motion Patterns**: Multi-directional sequences for special moves
  - **High Effort**: Actions requiring significant mechanical exertion
  - **Precision Timing**: Demanding inputs that test player coordination

#### Right Stick (Standard)

- **Horizontal**: Camera pan (-45° to +45°)
- **Vertical**: Camera zoom (0.8x to 1.5x)
- **Click**: Interact with nearby objects

### Move System Specification

#### Basic Moves (Always Available)

1. **Walk**: Hold any direction - 120 pixels/second movement
2. **Crouch**: Hold Down - 60 pixels/second, lower collision box
3. **Reach**: Hold Up - Extend pole upward, activate high switches

#### Inner Circle Moves (0-70% magnitude)

1. **Walk**: Hold direction - 120 pixels/second movement
2. **Crouch**: Hold down - Pole drops naturally, 60 pixels/second
3. **Reach**: Hold up - Simple pole extension for high objects
4. **Lean**: Hold diagonal - Slight pole angle adjustment

#### Circle Transition Moves (Inner → Outer)

1. **Stand Up**: Full outer circle rotation + inner circle up
   - **Mechanical Logic**: Requires full effort to lift pole from ground
   - **Input**: Outer circle 360° + inner circle ↑
   - **Duration**: 1.2 seconds total animation
   - **Effect**: Return to standing from crouch position

2. **Pole Swing**: Inner circle direction + outer circle opposite
   - **Mechanical Logic**: Momentum transfer from body to pole
   - **Input**: Inner ← + outer →, or inner → + outer ←
   - **Duration**: 0.8 seconds
   - **Effect**: Wide horizontal pole sweep

#### Outer Circle Moves (70-97% magnitude)

1. **Pole Vault**: Outer circle ↓↘→
   - **Mechanical Logic**: Plant pole with force, vault over
   - **Duration**: 1.0 seconds total animation
   - **Distance**: 200 pixels forward, 80 pixels height clearance
   - **Cooldown**: 0.3 seconds

2. **Spinning Swipe**: Outer circle →↓↘ + 270° rotation
   - **Mechanical Logic**: Full-body spinning motion with pole extended
   - **Duration**: 1.2 seconds total animation
   - **Range**: 360° attack, 120-pixel radius
   - **Cooldown**: 0.6 seconds

3. **Wall Slide**: Outer circle ←↙↓ (near wall)
   - **Mechanical Logic**: Brace pole against wall with controlled pressure
   - **Duration**: Continuous until ground contact
   - **Speed**: 80 pixels/second descent
   - **Requirement**: Within 25 pixels of wall surface

4. **Pole Plant**: Outer circle ↓ (hold 0.5s) + inner circle ↑
   - **Mechanical Logic**: Drive pole into ground, then precise positioning
   - **Duration**: Until released or 8 seconds maximum
   - **Effect**: Immunity to platform movement, stationary anchor
   - **Visual**: Pole extends deep into ground

5. **Sweep Attack**: Outer circle ↘→↗
   - **Mechanical Logic**: Low sweeping motion requiring full extension
   - **Duration**: 0.8 seconds total animation
   - **Range**: 180° arc, 150-pixel reach, ground level only
   - **Cooldown**: 0.4 seconds

#### Advanced Combination Moves (Room 15+)

1. **Vault-Spin Combo**: Pole Vault + immediate Spinning Swipe
   - **Input**: Outer ↓↘→ + outer →↓↘ + rotation
   - **Timing Window**: 0.2 seconds between moves
   - **Effect**: Aerial spinning attack after vault

2. **Plant-Sweep Combo**: Pole Plant + Sweep Attack
   - **Input**: Outer ↓ (hold) + inner ↑ + outer ↘→↗
   - **Effect**: Anchored position allows extended sweep range

3. **Recovery Stand**: Emergency stand-up from any position
   - **Input**: Outer circle double rotation + inner ↑
   - **Use Case**: Quick recovery from knockdown or awkward position
   - **Duration**: 0.6 seconds (faster than normal stand-up)

### Enemy Behaviors

### Patrol Bots

- **Movement**: Predictable back-and-forth patterns
- **Speed**: 80 pixels/second
- **Health**: Destroyed by Spinning Swipe
- **Behavior**: Simple obstacle, no AI detection
- **Strategy**: Timing-based avoidance or direct attack

### Sentry Bots

- **Position**: Fixed turret locations
- **Detection Range**: 200 pixels, 90° arc
- **Attack**: Single energy bolt every 2 seconds
- **Weakness**: Destroyed by Pole Vault approach + Spinning Swipe
- **Strategy**: Use cover or vault over projectiles

### Swarm Bots

- **Count**: 3-5 small robots per group
- **Behavior**: Move toward HOPE in formation
- **Speed**: 100 pixels/second
- **Weakness**: All destroyed by single Sweep Attack
- **Strategy**: Let them group up, then use low attack

### Shield Bots

- **Defense**: Front-facing energy shield
- **Weakness**: Vulnerable from behind or above
- **Strategy**: Pole Vault over shield, attack from behind
- **Health**: Requires two hits to destroy

### The Overseer (Final Boss)

- **Phase 1**: Environmental attacks (moving platforms, barriers)
- **Phase 2**: Direct energy beam attacks
- **Phase 3**: Summons other robot types
- **Strategy**: Use all learned moves in sequence
- **Victory**: Reach central console using advanced move combinations

## Level Progression

### Act 1: Foundation (Rooms 1-7)

**Focus**: Basic movement and first three techniques

#### Room 1: Movement Tutorial

- **Goal**: Learn basic 8-directional movement
- **Obstacles**: Simple platforms and gaps
- **Teaching**: Movement responsiveness and camera control
- **Success**: Reach exit using only basic movement

#### Room 2: Interaction Tutorial

- **Goal**: Learn right stick click for switches
- **Obstacles**: Doors requiring switch activation
- **Teaching**: Environmental interaction system
- **Success**: Open all doors and reach exit

#### Room 3: Pole Vault Introduction

- **Cutscene**: HOPE observes gap, learns Pole Vault (↓↘→)
- **Training Room**: Safe practice area with multiple gaps
- **Application**: Single gap requiring Pole Vault to cross
- **Success**: Execute Pole Vault successfully

#### Room 4: Pole Vault Integration

- **Goal**: Combine movement and Pole Vault
- **Obstacles**: Multiple gaps of varying sizes
- **Teaching**: Timing and positioning for vaulting
- **Success**: Navigate course using movement + Pole Vault

#### Room 5: Spinning Swipe Introduction

- **Cutscene**: HOPE encounters Patrol Bots, learns Spinning Swipe (→↓↘)
- **Training Room**: Practice area with target dummies
- **Application**: Room with 2-3 Patrol Bots to defeat
- **Success**: Clear all enemies using Spinning Swipe

#### Room 6: Combat Integration

- **Goal**: Combine movement, vaulting, and combat
- **Obstacles**: Patrol Bots + gaps requiring navigation
- **Teaching**: Combat timing and positioning
- **Success**: Reach exit while defeating all enemies

#### Room 7: Wall Slide Introduction

- **Cutscene**: HOPE faces tall wall, learns Wall Slide (←↙↓)
- **Training Room**: Safe practice wall with soft landing
- **Application**: Vertical descent challenge
- **Success**: Descend safely using Wall Slide

### Act 2: Mastery (Rooms 8-15)

**Focus**: Advanced techniques and enemy variety

#### Room 8-9: Sentry Bot Encounters

- **New Enemy**: Sentry Bots with ranged attacks
- **Strategy**: Use Pole Vault to avoid/approach
- **Teaching**: Ranged enemy tactics

#### Room 10: Pole Plant Introduction

- **Cutscene**: Moving platform challenge, learn Pole Plant (↓↑)
- **Training Room**: Various moving platform types
- **Application**: Navigate unstable platform sequence

#### Room 11: Environmental Mastery

- **Goal**: Combine all four techniques
- **Obstacles**: Mixed challenges requiring technique selection
- **Teaching**: Situational awareness and move choice

#### Room 12: Sweep Attack Introduction

- **Cutscene**: Swarm Bot encounter, learn Sweep Attack (↘→↗)
- **Training Room**: Practice against multiple small targets
- **Application**: Clear Swarm Bot groups

#### Room 13-14: Shield Bot Challenges

- **New Enemy**: Shield Bots requiring positional attacks
- **Strategy**: Vault over shields, attack from behind
- **Teaching**: Advanced combat positioning

#### Room 15: Combination Mastery

- **Goal**: Learn advanced move combinations
- **Teaching**: Chaining moves for complex challenges
- **Preparation**: Final skills before boss encounter

### Act 3: Climax (Rooms 16-20)

**Focus**: Master-level challenges and story resolution

#### Room 16-17: Gauntlet Challenges

- **Mixed Enemies**: All robot types in complex arrangements
- **Strategy**: Apply optimal move combinations
- **Teaching**: Combat efficiency and resource management

#### Room 18: Pre-Boss Challenge

- **Goal**: Demonstrate mastery of all techniques
- **Obstacles**: Comprehensive skill test
- **Story**: Final approach to Overseer chamber

#### Room 19: The Overseer Battle

- **Boss Fight**: Three-phase encounter
- **Mechanics**: All learned moves required
- **Story**: Confrontation with facility's AI controller

#### Room 20: Resolution

- **Goal**: Reach researcher
- **Story**: Final cutscene and relationship resolution
- **Ending**: Player choice influences final relationship dynamic

## Audio Design

### Dynamic Balance Audio

- **Stable**: Calm mechanical humming
- **Unstable**: Increasing tension, warning beeps
- **Falling**: Dramatic failure sound, silence before restart

### Environmental Audio

- **Wind**: Directional audio indicates strength and direction
- **Electrical**: Crackling increases as pole approaches danger
- **Robots**: Each type has distinct audio signature
- **Footsteps**: Change based on surface and movement speed

### Music System

- **Exploration**: Ambient, contemplative tracks
- **Tension**: Builds when enemies are near
- **Action**: Energetic during chase sequences
- **Story**: Emotional themes during narrative moments
- **Silence**: Used strategically for impact

## Visual Design Guidelines

### HOPE's Design

- **Silhouette**: Clearly readable against any background
- **Pole**: High contrast, always visible
- **Balance State**: Posture and pole angle indicate stability
- **Emotion**: Subtle animations show curiosity, determination, concern

### Environment Art

- **Clarity**: Gameplay elements clearly distinguished from decoration
- **Depth**: Parallax backgrounds suggest larger world
- **Storytelling**: Environmental details tell story without text
- **Accessibility**: High contrast, colorblind-friendly palette

### UI Elements

- **Balance Indicator**: Subtle visual cue, not intrusive
- **Interaction Prompts**: Appear only when in range
- **Camera Guides**: Subtle indicators for look-ahead areas
- **Minimal HUD**: No traditional health/score displays

## Technical Implementation Notes

### Physics Considerations

- **Pole Simulation**: Use Godot's RigidBody2D with custom constraints
- **Balance Calculation**: Real-time physics with stability thresholds
- **Collision Detection**: Precise collision for pole and HOPE separately
- **Performance**: Optimize for 60fps on target platforms

### Input Handling

- **Controller Support**: Xbox, PlayStation, generic gamepad compatibility
- **Dead Zone Configuration**: User-adjustable for accessibility
- **Input Buffering**: Brief buffer for precise timing actions
- **Rumble Feedback**: Contextual vibration for balance and danger

### Save System

- **Checkpoint**: Auto-save at room entry
- **Progress**: Track completed rooms and story beats
- **Settings**: Persist control preferences and accessibility options
- **Analytics**: Optional data collection for difficulty balancing
