extends Node

class_name Warp

signal warp(scene_destination, x, y, look_direction)

# warp points that lead 
export(Array, Vector2) var warp_points
export(Array, Vector2) var warp_destinations
export(String, FILE, "*.tscn") var warp_destination_scene

func get_warp_points() -> Array:
    return warp_points

func enter_warp(player_char : Player):
    var index : int = warp_points.find(player_char.get_grid_position())
    if index == -1:
        index = 0
    var new_location : Vector2 = warp_destinations[index]
    emit_signal("warp", warp_destination_scene, int(new_location.x), int(new_location.y), player_char.get_look_direction())