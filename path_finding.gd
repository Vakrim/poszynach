class_name PathFinding
extends Node2D

@export var rail_grid: RailGrid

var impl = AStar2D.new()

var impl_point_id = {}

var edges: Array[Edge] = []

func _ready() -> void:
    rail_grid.edge_created.connect(_on_edge_created)
    rail_grid.edge_removed.connect(_on_edge_removed)

func _on_edge_created(edge: Edge) -> void:
    var id = impl.get_available_point_id()
    impl.add_point(id, edge.world_position)
    impl_point_id[edge.id] = id
    edges.append(edge)

    for connection in rail_grid.get_connections(edge):
        var connection_id = impl_point_id[connection.id]
        impl.connect_points(id, connection_id)

    queue_redraw()

func _on_edge_removed(edge: Edge) -> void:
    impl.remove_point(impl_point_id[edge.id])
    impl_point_id.erase(edge.id)
    edges.erase(edge)
    queue_redraw()

func _draw() -> void:
    for edge in edges:
        draw_circle(edge.world_position, 20, Color(1, 0, 0, 0.3))
        draw_circle(impl.get_point_position(impl_point_id[edge.id]), 10, Color(0, 1, 0))
        draw_line(edge.world_position, edge.world_position + Vector2(20, 0).rotated(Direction.get_rotation(edge.direction)), Color(1, 0, 0))

        for c in impl.get_point_connections(impl_point_id[edge.id]):
            draw_line(impl.get_point_position(impl_point_id[edge.id]), impl.get_point_position(c), Color(0, 1, 0))
