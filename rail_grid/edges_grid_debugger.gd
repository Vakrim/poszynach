class_name EdgesGridDebugger
extends Node2D

@export var edges_grid: EdgesGrid

func _ready() -> void:
    edges_grid.edge_created.connect(repaint)
    edges_grid.edge_removed.connect(repaint)

func repaint(_edge_data) -> void:
    queue_redraw()

func _draw() -> void:
    for p in edges_grid.edges_by_position:
        var edge = edges_grid.edges_by_position[p] as Edge

        draw_circle(edge.world_position, 20, Color(1, 0, 0, 0.3))

        for connection in edges_grid.get_connections(edge):
            var start = edge.world_position
            var end = connection.to.get_edge().world_position

            draw_line(
                start,
                end,
                Color(0, 1, 0, 0.5),
                2
            )
