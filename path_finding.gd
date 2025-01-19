class_name PathFinding
extends Node2D

@export var rail_grid: RailGrid

var impl = AStar2D.new()

func _ready() -> void:
    rail_grid.edge_created.connect(_on_edge_created)
    rail_grid.edge_removed.connect(_on_edge_removed)
    rail_grid.connection_created.connect(_on_connection_created)

func _on_edge_created(edge: Edge.WithDirection) -> void:
    impl.add_point(
        edge.id,
        edge.get_edge().world_position
    )

    queue_redraw()

func _on_edge_removed(edge: Edge.WithDirection) -> void:
    impl.remove_point(edge.id)

    queue_redraw()

func _on_connection_created(from: Edge.WithDirection, to: Edge.WithDirection) -> void:
    impl.connect_points(from.id, to.id, false)

    queue_redraw()

func _draw() -> void:
    for point_id in impl.get_point_ids():
        var point = impl.get_point_position(point_id)

        draw_circle(point, 3, Color(1, 0, 0, 0.3))

        for connection in impl.get_point_connections(point_id):
            var start = point
            var end = impl.get_point_position(connection)

            draw_line(
                start,
                end,
                Color(0, 1, 0, 0.5),
                2
            )

func find_path(from: Edge.WithDirection, to: Edge.WithDirection) -> Array[Edge.WithDirection]:
    var ids = impl.get_id_path(from.id, to.id)

    var result: Array[Edge.WithDirection] = []
    for id in ids:
        result.append(rail_grid.edges[id])

    return result
