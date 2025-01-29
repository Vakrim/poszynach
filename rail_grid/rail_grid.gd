class_name RailGrid extends Node2D

signal edge_created(edge: Edge.WithDirection)
signal edge_removed(edge: Edge.WithDirection)
signal connection_created(from: Edge.WithDirection, to: Edge.WithDirection)

@onready var edges_grid = %EdgesGrid

var edges = Dictionary() # id: Edge.WithDirection

func _on_edge_created(edge: Edge) -> void:
    edges[edge.with_direction.id] = edge.with_direction
    edge_created.emit(edge.with_direction)

    edges[edge.with_opposite_direction.id] = edge.with_opposite_direction
    edge_created.emit(edge.with_opposite_direction)

    emit_connections_created(edge)

func _on_edge_removed(edge: Edge) -> void:
    edges.erase(edge.with_direction.id)
    edge_removed.emit(edge.with_direction)

    edges.erase(edge.with_opposite_direction.id)
    edge_removed.emit(edge.with_opposite_direction)

func create_edge(global_position_: Vector2) -> Edge:
    return edges_grid.create_edge(edges_grid.local_to_map(edges_grid.to_local(global_position_)))

func remove_edge(global_position_: Vector2) -> void:
    edges_grid.remove_edge(edges_grid.local_to_map(edges_grid.to_local(global_position_)))

func block_edge(global_position_: Vector2) -> void:
    edges_grid.block_edge(edges_grid.local_to_map(edges_grid.to_local(global_position_)))

func unblock_edge(global_position_: Vector2) -> void:
    edges_grid.unblock_edge(edges_grid.local_to_map(edges_grid.to_local(global_position_)))

func get_connections(edge: Edge) -> Array[Edge.Connection]:
    return edges_grid.get_connections(edge)

func emit_connections_created(edge: Edge) -> void:
    for connection in get_connections(edge):
        connection_created.emit(connection.from, connection.to)
        var opposite = connection.get_opposite()
        connection_created.emit(opposite.from, opposite.to)

func get_edges() -> Array[Edge.WithDirection]:
    var list: Array[Edge.WithDirection] = []
    for id in edges:
        var edge = edges[id] as Edge.WithDirection
        list.append(edge)
    return list
