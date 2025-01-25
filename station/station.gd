class_name Station
extends Node2D

var rail_grid: RailGrid

func _ready() -> void:
    rail_grid = get_parent().get_node('%RailGrid') as RailGrid

    assert(rail_grid, 'RailGrid not found')

    rail_grid.create_edge(global_position)
