# Events.gd
# This is an event bus that should hold all the signals that might be used between various applications.

extends Node

signal respawn ## Respawn the player back to the starting position
signal start_game ## Starts/restarts the main game
signal wave_start ## Triggered after wave grace period
signal wave_end ## Triggered when all enemies die or wave timer ends, whichever comes first
signal toggle_pause ## Triggered by pause UI
signal game_over ## Signal when the game is over by death
signal change_sound_volume ## Signal when the volume sliders are moved


# CARD UPGRADE EVENTS
signal UPGR_p_max_health_up(percentage : int)
signal UPGR_p_gp_radius_up(percentage : int)
signal UPGR_p_gp_dmg_up(percentage : int)
signal UPGR_p_speed_up(percentage : int)
signal UPGR_railgun_dmg_up(percentage : int)
signal UPGR_railgun_range_up(percentage : int)
signal UPGR_spine_whip_dmg_up(percentage : int)
signal UPGR_spine_whip_range_up(percentage : int)
signal UPGR_flamethrower_dmg_up(percentage : int)
signal UPGR_flamethrower_range_up(percentage : int)

signal upgrade_chosen

signal enemy_died
