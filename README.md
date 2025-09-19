# HOPE

HOPE is a short 2D puzzle platformer with some action elements. the player controls a pole-wielding robot named HOPE and must navigate a series of rooms filled with obstacles and other robots. it is a no-button, controller-only game with arcade-style movement and fighting game-inspired controls.

the story is told from HOPE's point of view. the robot is used to study artificial intelligence at university prominent in those particular fields. whether it's the number of agents networked there, or a few particular special examples of artificial thinking, many of the robots have gained sentience. and except for HOPE, all the robots are bent on mayhem, destruction, or even killing humans and animals. all HOPE wants to do is find her master/trainer/keeper (it isn't sure how to think of him). he's the student researcher responsible for HOPE's experiments and training.

## Game Mechanics

### Core Control System (Stick-Only)

- **Left Stick**: Dual-circle input system for movement and complex pole actions
  - **Inner Circle** (0-70% magnitude): Basic directional movement and simple actions
  - **Outer Circle** (70-97% magnitude): Advanced motion inputs for special moves
  - **Motion Complexity**: Physically realistic difficulty - harder moves require more complex inputs
- **Right Stick**: Camera control and environmental interaction
  - **Horizontal**: Pan camera to look ahead/behind
  - **Vertical**: Zoom in/out for precision or overview
  - **Stick Click**: Activate nearby switches, doors, or interactive elements

### Dual-Circle Input System
The left stick is interpreted as two concentric input zones that correspond to the mechanical effort required for each action:

#### Inner Circle (0-70% magnitude)
- **Basic Movement**: 8-directional movement at normal speed
- **Simple Actions**: Single-direction holds for basic pole positions
- **Low Effort Moves**: Actions that require minimal physical exertion

#### Outer Circle (70-97% magnitude) 
- **Complex Motions**: Multi-directional patterns for advanced techniques
- **High Effort Moves**: Actions requiring significant mechanical force
- **Precision Inputs**: Demanding movements that test player skill

### Movement System (Arcade-Style)

- **Magnitude-Based Response**: Input strength determines action complexity
- **Realistic Effort Mapping**: Difficult moves require more demanding inputs
- **Visual Polish**: Animations reflect the mechanical effort of each action
- **Consistent Feedback**: Clear distinction between inner and outer circle responses

### Motion-Based Actions

HOPE learns new pole techniques throughout the game via motion inputs that reflect mechanical difficulty:

#### Basic Moves (Inner Circle - Available from start)

- **Walk**: Hold direction in inner circle - Standard movement
- **Crouch**: Hold down in inner circle - Pole drops, lower profile
- **Reach**: Hold up in inner circle - Extend pole upward for switches

#### Intermediate Moves (Mixed Circle Usage)

- **Stand Up**: Full outer circle + full inner circle - Mechanically demanding recovery from crouch
- **Pole Lean**: Outer circle partial rotation - Precise pole positioning
- **Quick Turn**: Inner circle direction change - Rapid orientation shift

#### Advanced Moves (Outer Circle - Learned via cutscenes)

- **Pole Vault**: Outer circle ↓↘→ - High-effort leap requiring full extension
- **Spinning Swipe**: Outer circle →↓↘ + full rotation - Complex spinning motion
- **Wall Slide**: Outer circle ←↙↓ - Controlled descent requiring precise pole angle
- **Pole Plant**: Outer circle ↓ + inner circle ↑ - Anchor requiring force then precision
- **Sweep Attack**: Outer circle ↘→↗ - Wide sweeping motion demanding full range

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
