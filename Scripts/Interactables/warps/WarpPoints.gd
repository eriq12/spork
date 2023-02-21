extends Warp

class_name WarpPoints


# warp points that lead 
export(Array, Vector2) var warp_points
export(Array, Vector2) var warp_destinations

func get_warp_points() -> Array:
    return warp_points

func enter_warp(player_char : Player):
    # get coresponding index for warp, if no coresponding one exists, default to first destination
    var index : int = warp_points.find(player_char.get_grid_position())
    if index == -1:
        index = 0
    var new_location : Vector2 = warp_destinations[index]
    # signal game master to change position and/or map
    emit_signal("warp", warp_destination_scene, int(new_location.x), int(new_location.y), player_char.get_look_direction())