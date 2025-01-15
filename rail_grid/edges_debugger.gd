class_name EdgesDebugger
extends Node2D

@export var edges: Edges

func _ready() -> void:
    edges.edge_created.connect(repaint)
    edges.edge_removed.connect(repaint)

func repaint(_edge_data) -> void:
    queue_redraw()

func _draw() -> void:
    var connections_count = 0

    for p in edges.edges_by_position:
        var edge = edges.edges_by_position[p] as EdgeData

        draw_circle(edge.world_position, 20, Color(1, 0, 0, 0.3))

        for connection in edges.get_connections(edge):
            var start = edge.world_position
            var end = connection.edge_data.get_ref().world_position
            var connection_direction = (end - start).normalized()

            var padding = connection_direction.rotated(-PI / 2) * 10

            draw_line(
                start + padding,
                end + padding,
                Color(0, 1, 0, 0.5),
                2
            )

            draw_line(
                start - padding,
                start - padding + connection_direction * 10,
                Color(0, 1, 0, 0.5),
                4
            )

            connections_count += 1

    print("Connections count: ", connections_count)
