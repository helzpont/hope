# HOPE

HOPE is a short 2D puzzle platformer with some action elements. the player controls a pole-wielding robot named HOPE and must navigate a series of rooms filled with obstacles and other robots. it is a no-button, controller-only game with arcade-style movement and fighting game-inspired controls.

the story is told from HOPE's point of view. the robot is used to study artificial intelligence at university prominent in those particular fields. whether it's the number of agents networked there, or a few particular special examples of artificial thinking, many of the robots have gained sentience. and except for HOPE, all the robots are bent on mayhem, destruction, or even killing humans and animals. all HOPE wants to do is find her master/trainer/keeper (it isn't sure how to think of him). he's the student researcher responsible for HOPE's experiments and training.

## Game Mechanics

### Core Control System (Stick-Only)
- **Left Stick**: Controls HOPE's movement and pole actions using motion inputs
  - **Directional Movement**: 8-directional movement (N, NE, E, SE, S, SW, W, NW)
  - **Motion Commands**: Stick patterns trigger special moves (like fighting game inputs)
  - **Hold Directions**: Sustained inputs for continuous actions
- **Right Stick**: Camera control and environmental interaction
  - **Horizontal**: Pan camera to look ahead/behind
  - **Vertical**: Zoom in/out for precision or overview
  - **Stick Click**: Activate nearby switches, doors, or interactive elements

### Movement System (Arcade-Style)
- **Basic Movement**: Simple 8-directional movement with smooth animations
- **No Physics Simulation**: Movement is responsive and forgiving, not realistic
- **Visual Polish**: Animations suggest mechanical movement but prioritize gameplay feel
- **Consistent Speed**: HOPE moves at predictable speeds for reliable platforming

### Motion-Based Actions
HOPE learns new pole techniques throughout the game via motion inputs:

#### Basic Moves (Available from start)
- **Forward/Back**: Left stick left/right - Basic movement
- **Crouch**: Left stick down - Lower profile, slower movement
- **Reach Up**: Left stick up - Extend pole upward for high switches

#### Advanced Moves (Learned via cutscenes)
- **Pole Vault**: Down, Down-Forward, Forward (↓↘→) - Leap over gaps
- **Spinning Swipe**: Forward, Down, Down-Forward (→↓↘) - Clear multiple enemies
- **Wall Slide**: Back, Down-Back, Down (←↙↓) - Controlled descent on walls
- **Pole Plant**: Down, Up (↓↑) - Anchor pole for stability on moving platforms
- **Sweep Attack**: Down-Forward, Forward, Up-Forward (↘→↗) - Low attack against small enemies

### Learning System
- **Cutscene Introduction**: Each new move introduced with brief animated sequence
- **Training Room**: Safe practice area appears after learning new moves
- **Visual Cues**: On-screen motion indicators show required stick patterns
- **Progressive Complexity**: Moves build on each other logically

### Environmental Challenges
- **Moving Platforms**: Use Pole Plant technique for stability
- **Enemy Encounters**: Combat using learned pole techniques
- **Vertical Navigation**: Wall Slide and Pole Vault for traversal
- **Switch Puzzles**: Reach Up and Spinning Swipe for distant/multiple targets
- **Timed Sequences**: Reliable movement timing for precision challenges

## Story Elements

### HOPE's Character
- **Personality**: Curious, loyal, determined but uncertain about relationships
- **Internal Conflict**: Struggles with concepts of ownership, friendship, and purpose
- **Motivation**: Deep attachment to researcher, confusion about other robots' hostility
- **Growth Arc**: Learns to trust own judgment and define relationships on own terms

### Story Delivery
- **Linear Progression**: Story unfolds through scripted sequences between rooms
- **Cutscenes**: Brief animated sequences introduce new moves and advance plot
- **Enemy Interactions**: Hostile robots provide context through behavior and design
- **Environmental Storytelling**: Visual details support but don't replace direct narrative
- **No Exploration**: Focus on forward progression with clear story beats

### The University Setting
- **Research Facility**: Multiple interconnected buildings and labs
- **AI Laboratory**: HOPE's origin point, now overrun by hostile robots
- **Dormitories**: Where the researcher lived, HOPE's destination
- **Training Rooms**: Safe spaces that appear after learning new moves
- **Linear Path**: Clear route through facility with story-driven progression

### Hostile Robots
- **Patrol Bots**: Basic enemies defeated with Spinning Swipe
- **Sentry Bots**: Ranged enemies requiring Pole Vault to avoid/approach
- **Swarm Bots**: Multiple small enemies cleared with Sweep Attack
- **Shield Bots**: Require specific move combinations to defeat
- **The Overseer**: Final boss requiring mastery of all learned techniques

### Narrative Progression
- **Act 1**: Tutorial and basic move learning (Rooms 1-7)
- **Act 2**: Advanced techniques and enemy encounters (Rooms 8-15)
- **Act 3**: Master-level challenges and story climax (Rooms 16-20)
- **Cutscenes**: 5-6 brief story moments introducing moves and advancing plot

## Level Design Principles

### Room Structure
- Linear progression with single optimal path
- Each room teaches or tests one specific technique
- Clear visual language for interactive elements
- Immediate restart on failure with no punishment

### Move Introduction System
- **Cutscene**: 10-15 second animated demonstration
- **Training Room**: Safe practice area with visual guides
- **First Application**: Simple room requiring the new move
- **Integration**: Later rooms combine multiple techniques

### Accessibility Through Design
- **Visual Feedback**: Clear animations and UI for move execution
- **Audio Cues**: Distinct sounds for successful move inputs
- **Controller Rumble**: Feedback for move timing and environmental hazards
- **Forgiving Timing**: Generous input windows for motion commands

## Development Guidelines

### Technical Requirements
- **Engine**: Godot 4.x for animation system and controller support
- **Movement**: Arcade-style character controller with smooth animations
- **Input**: Motion detection system for fighting game-style inputs
- **Audio**: Dynamic feedback for moves and environmental interactions
- **Visuals**: Clear, readable art style emphasizing character animation

### Testing Priorities
1. **Motion Input**: Ensure stick patterns register reliably
2. **Controller Support**: Test with multiple controller types
3. **Move Timing**: Verify forgiving input windows
4. **Visual Clarity**: Confirm move demonstrations are clear
5. **Performance**: Maintain 60fps with smooth animations

### Code Organization
- Input system for motion pattern detection
- Animation state machine for move execution
- Cutscene system for story delivery and move introduction
- Linear level progression with checkpoint system
- Training room system for move practice

## Quick Start for Developers
1. Install Godot 4.x from https://godotengine.org/
2. Connect a controller (Xbox, PlayStation, or generic gamepad)
3. Open `project.godot` in Godot
4. Run the project to test basic movement and motion inputs
5. See `GAME_DESIGN.md` for detailed move specifications
6. See `TESTING.md` for test-driven development approach
7. See `.copilot-instructions.md` for AI development guidelines
