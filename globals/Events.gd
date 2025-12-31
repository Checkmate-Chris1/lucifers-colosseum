# Events.gd
# This is an event bus that should hold all the signals that might be used between various applications.

extends Node

# -- Example signals --
signal respawn ## Respawn the player back to the starting position
signal start_game ## Starts/restarts the main game
signal toggle_pause ## Triggered by pause UI
signal game_over ## Signal when the game is over by death
signal open_home ## Go back to home screen
signal open_shop ## Open shop UI
