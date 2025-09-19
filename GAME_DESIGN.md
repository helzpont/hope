# HOPE - Game Design Document

## Core Mechanics Specification

### Pole Physics System

#### Balance Calculation
```
Balance State = (Pole Angle + Movement Velocity + External Forces) / Stability Threshold
- Stable: Balance State < 0.3
- Unstable: Balance State 0.3-0.7 (warning indicators)
- Falling: Balance State > 0.7 (failure state)
```

#### Pole Properties
- **Length**: 2.5x HOPE's height
- **Weight**: Affects momentum and recovery time
- **Flexibility**: Slight bend under stress, returns to straight
- **Collision**: Full physics collision with environment

#### Control Mapping
- **Left Stick X-Axis**: 
  - Range: -1.0 to 1.0
  - Dead Zone: 0.1
  - Movement Speed: `stick_input * max_speed * balance_modifier`
  - Pole Lean: `stick_input * max_lean_angle`

- **Left Stick Y-Axis**:
  - Up: Extend pole upward (reduce center of gravity)
  - Down: Lower pole/crouch (increase stability, reduce speed)
  - Range affects balance recovery speed

- **Right Stick X-Axis**:
  - Camera pan: -45° to +45° from HOPE's position
  - Smooth interpolation with 0.2s lag

- **Right Stick Y-Axis**:
  - Camera zoom: 0.8x to 1.5x base zoom
  - Closer zoom for precision, farther for planning

- **Right Stick Click**:
  - Interaction radius: 1.5x pole length
  - Activates switches, doors, collectibles
  - Visual feedback: highlight interactive objects in range

### Movement States

#### Walking (Default)
- **Speed**: 100 pixels/second
- **Balance Window**: ±30° pole angle before instability
- **Recovery Time**: 0.5s to return to stable from unstable
- **Audio**: Soft mechanical footsteps

#### Running (Fast Movement)
- **Trigger**: Left stick magnitude > 0.8
- **Speed**: 200 pixels/second
- **Balance Window**: ±15° pole angle (more sensitive)
- **Recovery Time**: 1.0s (harder to recover)
- **Audio**: Faster, more urgent footsteps
- **Visual**: HOPE leans forward, pole trails behind

#### Pole Vaulting
- **Trigger**: Running + approach gap + right stick up
- **Mechanics**: 
  - Plant pole at gap edge
  - Momentum carries HOPE in arc
  - Must land with balanced pole angle
  - Failure results in fall into gap
- **Range**: Up to 3x HOPE's height horizontally

#### Wall Sliding
- **Trigger**: Pole contacts wall while moving
- **Mechanics**:
  - Pole slides along wall surface
  - Controlled descent on vertical surfaces
  - Can change direction by adjusting pole angle
- **Speed**: 50 pixels/second descent

### Environmental Systems

#### Moving Platforms
- **Tilt Response**: Platform angle affects HOPE's balance
- **Momentum Transfer**: Platform movement adds to HOPE's velocity
- **Stability Zones**: Some platforms have railings (easier balance)
- **Timing**: Platforms move in predictable patterns

#### Wind Zones
- **Visual Indicator**: Particle effects show wind direction/strength
- **Physics Effect**: Constant force applied to HOPE and pole
- **Adaptation**: Player must lean into wind to maintain balance
- **Intensity Levels**:
  - Light: 20% balance difficulty increase
  - Moderate: 50% increase, affects movement speed
  - Strong: 100% increase, requires constant adjustment

#### Electrical Fields
- **Detection**: Pole vibrates (controller rumble) when near
- **Visual**: Crackling energy effects, sparks
- **Danger**: Instant failure if HOPE or pole touches
- **Navigation**: Must find safe paths around or under fields

## Enemy Behaviors

### Patrol Bots
- **Movement**: Fixed rectangular paths
- **Speed**: 80 pixels/second
- **Detection**: None (purely obstacle-based)
- **Collision**: Pushes HOPE, disrupts balance
- **Strategy**: Timing-based avoidance

### Sentry Bots
- **Position**: Fixed locations with 180° detection arc
- **Detection Range**: 300 pixels
- **Alert State**: 2-second warning before firing
- **Projectile**: Energy bolt, 150 pixels/second
- **Cooldown**: 3 seconds between shots
- **Weakness**: Blind spots behind and to sides

### Swarm Bots
- **Count**: 3-5 per group
- **Behavior**: Follow simple flocking algorithm
- **Speed**: 120 pixels/second
- **Attack**: Collision damage, disrupts balance severely
- **Weakness**: Pole can knock them away with swing motion
- **Spawn**: Triggered by proximity to certain areas

### Mimic Bots
- **Behavior**: Copy HOPE's movements with 1-second delay
- **Challenge**: Creates mirror puzzles
- **Failure**: If mimic falls, HOPE also fails
- **Strategy**: Requires planning movement sequences
- **Visual**: Slightly transparent, different color

### The Overseer (Boss)
- **Phase 1**: Controls facility systems (doors, platforms)
- **Phase 2**: Direct attacks with energy beams
- **Phase 3**: Summons other robot types
- **Weakness**: Must use environment against it
- **Victory Condition**: Reach central console while avoiding attacks

## Level Progression

### Act 1: Laboratory Escape (Rooms 1-5)
**Learning Objectives**: Basic movement, balance, simple obstacles

#### Room 1: Tutorial
- **Goal**: Learn basic movement and balance
- **Obstacles**: None
- **Interactive**: Practice pole with switches
- **Success Metric**: Reach exit without falling

#### Room 2: First Gap
- **Goal**: Learn pole vaulting
- **Obstacles**: Single gap, 2x HOPE's height
- **Teaching**: Visual guide shows pole placement
- **Success Metric**: Successfully vault gap

#### Room 3: Moving Platform
- **Goal**: Balance on moving surface
- **Obstacles**: Single platform, slow movement
- **Teaching**: Platform telegraphs movement
- **Success Metric**: Ride platform to exit

#### Room 4: First Enemy
- **Goal**: Avoid Patrol Bot
- **Obstacles**: Single Patrol Bot, simple path
- **Teaching**: Bot path is clearly visible
- **Success Metric**: Reach exit without collision

#### Room 5: Combination
- **Goal**: Combine learned skills
- **Obstacles**: Gap + moving platform + patrol bot
- **Teaching**: Multiple solution paths available
- **Success Metric**: Use any valid strategy to exit

### Act 2: University Grounds (Rooms 6-15)
**Learning Objectives**: Advanced movement, enemy types, environmental hazards

#### Rooms 6-8: Wind Zones
- Progressive wind intensity
- Learn to compensate for external forces
- Introduce wall sliding in windy areas

#### Rooms 9-11: Sentry Bots
- Detection mechanics
- Cover and timing
- Using pole to block projectiles

#### Rooms 12-13: Swarm Encounters
- Multiple enemy management
- Pole combat mechanics
- Escape vs. fight decisions

#### Rooms 14-15: Electrical Hazards
- Pole detection of danger
- Complex navigation puzzles
- Precision movement requirements

### Act 3: Dormitory Infiltration (Rooms 16-20)
**Learning Objectives**: Master-level challenges, story climax

#### Rooms 16-17: Mimic Puzzles
- Movement planning
- Sequence memorization
- Cooperative failure states

#### Room 18: Multi-Enemy Gauntlet
- All enemy types present
- Multiple solution paths
- Resource management (stamina/balance)

#### Room 19: The Overseer Approach
- Environmental storytelling
- Final skill check before boss
- Multiple checkpoint saves

#### Room 20: The Overseer Battle
- Three-phase boss fight
- All mechanics utilized
- Story resolution

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