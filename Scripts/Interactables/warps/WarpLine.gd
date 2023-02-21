extends Warp

class_name WarpLine

# sets whether warp line is vertical or horizontal
export(bool) var vertical_source : bool
# source and destination points (source point of area, top left)
export(Vector2) var source : Vector2

# sets whether destination line is vertical or horizontal
export(bool) var vertical_destination : bool
# sets whether destination line is vertical or horizontal
export(Vector2) var destination : Vector2

# length of warp line
export(int) var length: int

func get_warp_points() -> Array:
    # array to return
    var warp_points : Array = []
    # source of propogation
    var warp_point : Vector2 = source
    # direction of propogation
    var expand_direction = Vector2.DOWN if vertical_source else Vector2.RIGHT
    # iterate through all points in direction and add to return array
    for _i in range(length):
        warp_points.push_back(warp_point)
        warp_point += expand_direction
    return warp_points

func enter_warp(player_char : Player):
    # location difference
    var difference : Vector2 = player_char.get_grid_position() - source
    # find coresponding point
    var warp_distance : int = int(difference.y if vertical_source else difference.x)
    var destination_position : Vector2 = destination + (Vector2.DOWN if vertical_destination else Vector2.RIGHT) * warp_distance
    # signal game master to change position and/or map
    emit_signal("warp", warp_destination_scene, int(destination_position.x), int(destination_position.y), player_char.get_look_direction())