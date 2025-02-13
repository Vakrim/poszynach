class_name InitialBuilder
extends Node

@onready var edges_grid = %EdgesGrid

func create_initial_setup(initial_rail_setup: Node2D) -> void:
    var edges = edges_grid.get_used_cells_by_id(0, edges_grid.CONNECTION_PLACEHOLDER_TILE)

    var polygons = initial_rail_setup.get_children() as Array[Polygon2D]

    for polygon in polygons:
        for edge in edges:
            if Geometry2D.is_point_in_polygon(polygon.to_local(edges_grid.to_global(edges_grid.map_to_local(edge))), polygon.polygon):
                edges_grid.create_edge(edge)
                edges_grid.block_edge(edge)

        polygon.queue_free()
