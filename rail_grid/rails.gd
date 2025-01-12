extends TileMapLayer

func _on_edges_edge_changed(master_position: Vector2i, connections_index: int) -> void:
    set_cell(
        master_position,
        0,
        Vector2i(connections_index, 0)
    )
