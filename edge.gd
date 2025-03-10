class_name Edge

static var next_id = 0

var id: int
var grid_position: Vector2i
var world_position: Vector2
var direction: TileSet.CellNeighbor
var with_direction: WithDirection # TODO: should this be weakref?
var with_opposite_direction: WithDirection # TODO: should this be weakref?

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

    self.with_direction = WithDirection.new(
        self,
        direction_
    )

    self.with_opposite_direction = WithDirection.new(
        self,
        Direction.get_opposite_direction(direction_)
    )

class WithDirection:
    static var next_id = 0

    var id: int
    var edge: Edge
    var direction: TileSet.CellNeighbor

    func _init(
        edge_: Edge,
        direction_: TileSet.CellNeighbor
    ) -> void:
        self.id = next_id
        next_id += 1
        self.edge = edge_
        self.direction = direction_

    func get_edge() -> Edge:
        return self.edge

    func get_opposite() -> WithDirection:
        if self.edge.with_direction == self:
            return self.edge.with_opposite_direction
        else:
            return self.edge.with_direction

class Connection:
    var from: WithDirection
    var to: WithDirection

    func _init(from_: WithDirection, to_: WithDirection) -> void:
        self.from = from_
        self.to = to_

    func get_opposite() -> Connection:
        return Connection.new(self.to.get_opposite(), self.from.get_opposite())
