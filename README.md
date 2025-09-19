# HOPE

HOPE is a short 2D puzzle platformer with some action elements. the player controls a pole-balancing robot named HOPE and must navigate a series of rooms filled with obstacles and other robots. it is a no-button, controller-only game.

the story is told from HOPE's point of view. the robot is used to study artificial intelligence at university prominent in those particular fields. whether it's the number of agents networked there, or a few particular special examples of artificial thinking, many of the robots have gained sentience. and except for HOPE, all the robots are bent on mayhem, destruction, or even killing humans and animals. all HOPE wants to do is find her master/trainer/keeper (it isn't sure how to think of him). he's the student researcher responsible for HOPE's experiments and training.

## Game Mechanics

### Core Control System (Stick-Only)
- **Left Stick**: Controls HOPE's movement and pole balance
  - **Horizontal**: Move left/right, lean pole for balance
  - **Vertical**: Adjust pole angle for precise balance, crouch/extend for momentum
- **Right Stick**: Camera control and environmental interaction
  - **Horizontal**: Pan camera to look ahead/behind
  - **Vertical**: Zoom in/out for precision or overview
  - **Stick Click**: Activate nearby switches, doors, or interactive elements

### Pole-Balancing Physics
- HOPE carries a long pole that affects movement and balance
- Pole physics respond to momentum, gravity, and environmental forces
- Balance is critical: losing balance causes HOPE to fall and restart the room
- Pole can be used to:
  - Bridge small gaps
  - Activate distant switches
  - Block projectiles from hostile robots
  - Detect electrical fields (pole vibrates via controller rumble)

### Movement Mechanics
- **Walking**: Slow, stable movement with good balance control
- **Running**: Faster movement but requires more precise balance
- **Pole Vaulting**: Use pole momentum to cross larger gaps
- **Wall Sliding**: Lean pole against walls to slide down safely
- **Momentum Conservation**: Physics-based movement where speed and direction matter

### Environmental Challenges
- **Moving Platforms**: Require balance adjustments as they tilt
- **Wind Zones**: Push HOPE and affect pole balance
- **Electrical Fields**: Dangerous areas that HOPE must navigate around
- **Narrow Ledges**: Require precise balance and slow movement
- **Rotating Obstacles**: Timing-based challenges that test balance recovery

## Story Elements

### HOPE's Character
- **Personality**: Curious, loyal, determined but uncertain about relationships
- **Internal Conflict**: Struggles with concepts of ownership, friendship, and purpose
- **Motivation**: Deep attachment to researcher, confusion about other robots' hostility
- **Growth Arc**: Learns to trust own judgment and define relationships on own terms

### The University Setting
- **Research Facility**: Multiple interconnected buildings and labs
- **AI Laboratory**: HOPE's origin point, now overrun by hostile robots
- **Dormitories**: Where the researcher lived, HOPE's destination
- **Maintenance Tunnels**: Hidden paths that avoid main robot populations
- **Outdoor Courtyards**: Open areas with environmental hazards

### Hostile Robots
- **Patrol Bots**: Follow predictable paths, can be avoided with timing
- **Sentry Bots**: Stationary but have detection fields, shoot energy projectiles
- **Swarm Bots**: Small, fast robots that attack in groups
- **Mimic Bots**: Copy HOPE's movements, creating mirror-puzzle challenges
- **The Overseer**: Final boss robot that has taken control of the facility

### Narrative Progression
- **Act 1**: Escape the laboratory, learn basic controls and story setup
- **Act 2**: Navigate university grounds, encounter different robot types
- **Act 3**: Infiltrate dormitories, face The Overseer, find the researcher
- **Resolution**: HOPE's choice about their relationship and future

## Level Design Principles

### Room Structure
- Each room is a self-contained challenge
- Multiple solution paths encourage experimentation
- Environmental storytelling through robot remains and facility decay
- Progressive difficulty that teaches new mechanics

### Accessibility Through Design
- Visual cues for balance state (pole color, HOPE's posture)
- Audio feedback for balance, danger, and interaction
- Controller rumble for environmental hazards and balance warnings
- Clear visual language for interactive vs. decorative elements

## Development Guidelines

### Technical Requirements
- **Engine**: Godot 4.x for advanced physics and controller support
- **Physics**: Custom pole-balancing system with realistic momentum
- **Input**: Robust controller input with dead zone configuration
- **Audio**: Dynamic audio that responds to balance state and environment
- **Visuals**: Clean, readable art style that supports gameplay clarity

### Testing Priorities
1. **Balance Physics**: Ensure pole mechanics feel responsive and fair
2. **Controller Input**: Test with multiple controller types and configurations
3. **Accessibility**: Verify visual and audio cues are clear and helpful
4. **Difficulty Curve**: Ensure each room teaches before it tests
5. **Performance**: Maintain 60fps on target platforms

### Code Organization
- Separate systems for movement, balance, camera, and interaction
- Modular enemy AI that can be easily extended
- Scene-based level loading with persistent game state
- Comprehensive input mapping system for different controllers

## Quick Start for Developers

1. Install Godot 4.x from https://godotengine.org/
2. Connect a controller (Xbox, PlayStation, or generic gamepad)
3. Open `project.godot` in Godot
4. Run the project to test basic movement and balance
5. See `GAME_DESIGN.md` for detailed mechanics specifications
6. See `TESTING.md` for test-driven development approach
7. See `.copilot-instructions.md` for AI development guidelines
