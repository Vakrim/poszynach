class_name Direction

const TOP_RIGHT = TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE
const RIGHT = TileSet.CELL_NEIGHBOR_RIGHT_SIDE
const BOTTOM_RIGHT = TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE
const BOTTOM_LEFT = TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE
const LEFT = TileSet.CELL_NEIGHBOR_LEFT_SIDE
const TOP_LEFT = TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE

static func get_opposite_direction(direction: TileSet.CellNeighbor) -> TileSet.CellNeighbor:
    match direction:
        TOP_RIGHT:
            return BOTTOM_LEFT
        RIGHT:
            return LEFT
        BOTTOM_RIGHT:
            return TOP_LEFT
        BOTTOM_LEFT:
            return TOP_RIGHT
        LEFT:
            return RIGHT
        TOP_LEFT:
            return BOTTOM_RIGHT
        _:
            assert(false, "Direction not found")
            return RIGHT

static func get_rotation(direction: TileSet.CellNeighbor) -> float:
    match direction:
        TOP_RIGHT:
            return -PI / 3.0
        RIGHT:
            return 0.0
        BOTTOM_RIGHT:
            return PI / 3.0
        BOTTOM_LEFT:
            return 2 * PI / 3.0
        LEFT:
            return PI
        TOP_LEFT:
            return -2 * PI / 3.0
        _:
            assert(false, "Direction not found")
            return 0.0

static func get_vec(direction: TileSet.CellNeighbor) -> Vector2:
    return Vector2.RIGHT.rotated(get_rotation(direction))
