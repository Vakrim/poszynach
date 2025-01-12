@tool
extends TileMapLayer

@export var repaint: bool:
    set(new_value):
        init_center_of_master_tiles()

signal edge_changed(master_position: Vector2i, connections_index: int)

const CONNECTION_TILE = Vector2i(0, 0)
const CONNECTION_PLACEHOLDER_TILE = Vector2i(2, 0)

func init_center_of_master_tiles() -> void:
    clear()
    for x in range(-20, 20):
        for y in range(-20, 20):
            if is_tile_center(Vector2i(x, y)):
                continue
            set_cell(
                Vector2i(x, y),
                0,
                CONNECTION_PLACEHOLDER_TILE
            )

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var mouse_event = event as InputEventMouseButton
        var clicked_tile_position = local_to_map(to_local(get_global_mouse_position()))
        var clicked_tile = get_cell_atlas_coords(clicked_tile_position)

        if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed and clicked_tile == CONNECTION_PLACEHOLDER_TILE:
            set_cell(clicked_tile_position, 0, CONNECTION_TILE)
            notify_master_tiles_about_change(clicked_tile_position)
        elif mouse_event.button_index == MOUSE_BUTTON_RIGHT and mouse_event.pressed and clicked_tile == CONNECTION_TILE:
            set_cell(clicked_tile_position, 0, CONNECTION_PLACEHOLDER_TILE)
            notify_master_tiles_about_change(clicked_tile_position)

func notify_master_tiles_about_change(changed_edge_tile_position: Vector2i) -> void:
    for neighbor in get_surrounding_cells(changed_edge_tile_position):
        if !is_tile_center(neighbor):
            continue

        var master_tile_connections_index = get_master_tile_connections_index(neighbor)
        var master_position = from_edge_to_master_tile(neighbor)
        edge_changed.emit(master_position, master_tile_connections_index)

func get_master_tile_connections_index(edge_tile_position: Vector2i) -> int:
    var index = 0

    if get_cell_atlas_coords(get_neighbor_cell(edge_tile_position, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE)) == CONNECTION_TILE:
        index += 1

    if get_cell_atlas_coords(get_neighbor_cell(edge_tile_position, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)) == CONNECTION_TILE:
        index += 2

    if get_cell_atlas_coords(get_neighbor_cell(edge_tile_position, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE)) == CONNECTION_TILE:
        index += 4

    if get_cell_atlas_coords(get_neighbor_cell(edge_tile_position, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE)) == CONNECTION_TILE:
        index += 8

    if get_cell_atlas_coords(get_neighbor_cell(edge_tile_position, TileSet.CELL_NEIGHBOR_LEFT_SIDE)) == CONNECTION_TILE:
        index += 16

    if get_cell_atlas_coords(get_neighbor_cell(edge_tile_position, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE)) == CONNECTION_TILE:
        index += 32

    return index

func is_tile_center(tile_position: Vector2i) -> bool:
    return tile_position.y % 2 == 0 and (tile_position.x + floori(tile_position.y / 2.0)) % 2 == 0

func from_master_to_edge_tile(master_position: Vector2i) -> Vector2i:
    return Vector2i(2 * master_position.x + (master_position.y % 2), 2 * master_position.y)

@warning_ignore("integer_division")
func from_edge_to_master_tile(edge_position: Vector2i) -> Vector2i:
    return Vector2i(floori(edge_position.x / 2.0), edge_position.y / 2)
