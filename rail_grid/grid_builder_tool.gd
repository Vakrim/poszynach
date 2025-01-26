@tool
class_name GridBuilderTool
extends Node

@onready var edges_grid = %EdgesGrid
@onready var grid = %Grid

@export var size: int = 30:
    set(new_value):
        assert(new_value > 0 and new_value <= 100, "Size must be between 1 and 100")
        size = new_value
        if Engine.is_editor_hint():
            generate_grid()

func generate_grid() -> void:
    edges_grid.init_center_of_master_tiles(size * 2)

    grid.clear()
    for x in range(-size, size):
        for y in range(-size, size):
            grid.set_cell(
                Vector2i(x, y),
                0,
                Vector2i(0, 0)
            )
