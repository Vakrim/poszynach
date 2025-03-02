class_name InitialBuilder
extends Node

@onready var edges_grid = %EdgesGrid

func create_initial_setup(initial_rail_setup: Node2D) -> void:
    var edges = edges_grid.get_used_cells_by_id(0, edges_grid.CONNECTION_PLACEHOLDER_TILE)

    var create_rail_node = initial_rail_setup.get_node("CreateRail")
    assert(create_rail_node, "CreateRail node not found")

    var polygons = create_rail_node.get_children() as Array[Polygon2D]

    for polygon in polygons:
        for edge in edges:
            if Geometry2D.is_point_in_polygon(polygon.to_local(edges_grid.to_global(edges_grid.map_to_local(edge))), polygon.polygon):
                edges_grid.create_edge(edge)
                edges_grid.block_edge(edge)

        polygon.queue_free()

    create_rail_node.queue_free()

    var block_node = initial_rail_setup.get_node("Block")
    assert(block_node, "Block node not found")

    var block_polygons = block_node.get_children() as Array[Polygon2D]

    for polygon in block_polygons:
        for edge in edges:
            if Geometry2D.is_point_in_polygon(polygon.to_local(edges_grid.to_global(edges_grid.map_to_local(edge))), polygon.polygon):
                edges_grid.block_edge(edge)

        polygon.queue_free()

    block_node.queue_free()
