extends Node

class_name Warp

signal warp(scene_destination, x, y, look_direction)

# warp scene destination
export(String, FILE, "*.tscn") var warp_destination_scene

func get_warp_points() -> Array:
    return []

func enter_warp(_player_char : Player):
    pass