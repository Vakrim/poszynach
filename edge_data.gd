class_name EdgeData

static var next_id = 0

var id: int
var grid_position: Vector2i
var world_position: Vector2
var direction: TileSet.CellNeighbor
var with_direction: EdgeWithDirection
var with_opposite_direction: EdgeWithDirection

func _init(
    grid_position_: Vector2i,
    world_position_: Vector2,
    direction_: TileSet.CellNeighbor,
) -> void:
    self.id = next_id
    next_id += 1
    self.grid_position = grid_position_
    self.world_position = world_position_
    self.direction = direction_

    self.with_direction = EdgeWithDirection.new(
        self,
        direction_
    )

    self.with_opposite_direction = EdgeWithDirection.new(
        self,
        Direction.get_opposite_direction(direction_)
    )

class EdgeWithDirection:
    var edge_data: WeakRef
    var direction: TileSet.CellNeighbor

    func _init(
        edge_data_: EdgeData,
        direction_: TileSet.CellNeighbor
    ) -> void:
        self.edge_data = weakref(edge_data_)
        self.direction = direction_
