extends TileMapLayer

func _ready() -> void:
    for x in range(-10, 10):
        for y in range(-10, 10):
            set_cell(
                Vector2i(x, y),
                0,
                Vector2i(0, 0)
            )
