class_name Station
extends Node2D

var rail_grid: RailGrid
var edge: Edge.WithDirection

var transport_requests: Array[TransportRequest] = []

func _ready() -> void:
    rail_grid = get_parent().get_node('%RailGrid') as RailGrid

    assert(rail_grid, 'RailGrid not found')

    var new_edge = rail_grid.create_edge(global_position)

    var station_direction = Direction.get_direction_from_rotation(rotation)

    if station_direction == new_edge.with_direction.direction:
        edge = new_edge.with_direction
    elif station_direction == new_edge.with_opposite_direction.direction:
        edge = new_edge.with_opposite_direction
    else:
        assert(false, 'Station rotation does not match edge direction')

    rail_grid.block_edge(global_position)

func _exit_tree() -> void:
    if rail_grid:
        rail_grid.remove_edge(global_position)
        rail_grid.unblock_edge(global_position)
