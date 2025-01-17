class_name RailGrid extends Node2D

signal edge_created(edge: Edge.WithDirection)
signal edge_removed(edge: Edge.WithDirection)
signal connection_created(from: Edge.WithDirection, to: Edge.WithDirection)

func _on_edge_created(edge: Edge) -> void:
    edge_created.emit(edge.with_direction)
    edge_created.emit(edge.with_opposite_direction)

    emit_connections_created(edge)

func _on_edge_removed(edge: Edge) -> void:
    edge_removed.emit(edge.with_direction)
    edge_removed.emit(edge.with_opposite_direction)

func get_connections(edge: Edge) -> Array[Edge.Connection]:
    return %EdgesGrid.get_connections(edge)

func emit_connections_created(edge: Edge) -> void:
    for connection in get_connections(edge):
        connection_created.emit(connection.from, connection.to)
        var opposite = connection.get_opposite()
        connection_created.emit(opposite.from, opposite.to)
