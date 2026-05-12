## Yocha: Historical Economic Simulation
An educational, narrative-driven historical simulator built in the Godot Engine (GDScript). This project explores regional Nigerian history through interactive resource management and economic simulation.

Rather than a traditional survival game with strict win/loss states, Yocha is engineered as an educational experience with a fixed historical timeline, allowing players to navigate the economic realities of 1929 Nigeria without the friction of "game over" screens.
Currently featuring Module 1: The Aba Women's Riot (1929).

## Tech Stack & Engineering Environment
Game Engine: Godot Engine (v4.x)

Language: GDScript (Object-Oriented, dynamically typed)

State Management: JSON-based data serialisation for game states

Architecture: Component-based UI, Signal-driven event handling, Singleton (Autoload) persistence

Platform Targets: HTML5 (WebAssembly), Windows, and Linux.

## Core System Architecture
1. Event-Driven UI and Scene Routing
The application utilises Godot's Observer pattern (Signals) to manage asynchronous scene transitions and user input without tightly coupling the UI to the underlying game logic.

Dynamic Routing: A centralised flow controller manages the instantiation and freeing of complex scene trees (Splash Screen -> Main Menu -> Simulation Engine).

Responsive Containers: The UI relies heavily on nested VBoxContainer and HBoxContainer nodes, combined with Control anchors, to ensure the interface mathematically scales across desktop and browser aspect ratios.

Custom Masking: Implements advanced node stacking (e.g., TextureRect, ColorRect tinting, and TextureButton with alpha clipping) to create modern, app-like interactive cards that bypass Godot's default rectangular bounds.

## State Persistence & Data Serialisation
To track player decisions across the fixed timeline, the game relies on a custom I/O architecture rather than hardcoded narrative scripts.

JSON Serialisation: The GameManager script utilises Godot's FileAccess class to serialise the player's current inventory, financial balance, and history log into dictionaries, which are then written to a .json file.

Auto-Save Pipeline: State data is automatically captured and written to disk during scene exits and pause states, ensuring zero data loss if the simulation is interrupted.

## Economic & Market Simulation Engine
At the core of the Aba Women's module is a dynamic trading engine tracking colonial economic variables.

Inventory Clamping: Array and scalar operations heavily utilise mathematical clamping to prevent integer underflow, ensuring players cannot achieve negative resource balances during high-frequency market interactions.

Real-Time Data Parsing: Player inputs are actively parsed to update the UI labels, adjust the underlying financial variables, and push strings to the active history log sequentially.

## Process Mode Bypassing (State Machines)
The application features a fully functional pause-and-resume overlay that directly manipulates engine execution.

Time Scale Freezing: Utilising get_tree().paused = true to freeze all simulation logic, physics, and input processing.

## Installation & Build Instructions
Running from Source
Clone this repository.

Open the Godot Engine and click Import.

Navigate to the cloned folder and select the project.godot file.

Press F5 to run the project.
## Play the Exported Build
The simulation is fully packaged and executable via browser or desktop native apps: https://legendv.itch.io/yocha.
