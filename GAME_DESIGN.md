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

### Move System Specification

#### Basic Moves (Always Available)

1. **Walk**: Hold any direction - 120 pixels/second movement
2. **Crouch**: Hold Down - 60 pixels/second, lower collision box
3. **Reach**: Hold Up - Extend pole upward, activate high switches

#### Learned Moves (Introduced via Cutscenes)

##### Pole Vault (Room 3)

- **Input**: ↓↘→ (Down, Down-Forward, Forward)
- **Effect**: Leap forward 200 pixels, clear 80-pixel height obstacles
- **Duration**: 0.8 seconds total animation
- **Cooldown**: 0.2 seconds before next move

##### Spinning Swipe (Room 5)

- **Input**: →↓↘ (Forward, Down, Down-Forward)
- **Effect**: 360° attack, 100-pixel radius, destroys multiple enemies
- **Duration**: 1.0 seconds total animation
- **Cooldown**: 0.5 seconds before next move

##### Wall Slide (Room 7)

- **Input**: ←↙↓ (Back, Down-Back, Down) near wall
- **Effect**: Controlled descent at 80 pixels/second
- **Duration**: Until reaching ground or input released
- **Requirement**: Must be within 20 pixels of wall

##### Pole Plant (Room 10)

- **Input**: ↓↑ (Down, Up)
- **Effect**: Anchor in place, immune to moving platform effects
- **Duration**: Until input released or 5 seconds maximum
- **Visual**: Pole extends into ground, HOPE becomes stationary

##### Sweep Attack (Room 12)

- **Input**: ↘→↗ (Down-Forward, Forward, Up-Forward)
- **Effect**: Low horizontal attack, 150-pixel range, hits ground-level enemies
- **Duration**: 0.6 seconds total animation
- **Cooldown**: 0.3 seconds before next move

#### Advanced Combinations (Room 15+)

- **Vault-Swipe**: Pole Vault immediately followed by Spinning Swipe
- **Plant-Sweep**: Pole Plant to stabilize, then Sweep Attack
- **Slide-Vault**: Wall Slide into Pole Vault for momentum preservation

## Enemy Behaviors

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
