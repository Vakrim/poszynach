class_name RailGrid extends Node2D

signal edge_created(edge_data: EdgeData)

signal edge_removed(edge_data: EdgeData)

func _on_edge_created(edge_data: EdgeData) -> void:
    edge_created.emit(edge_data)

func _on_edge_removed(edge_data: EdgeData) -> void:
    edge_removed.emit(edge_data)

func get_connections(edge_data: EdgeData) -> Array[EdgeData]:
    return %Edges.get_connections(edge_data.grid_position)
