class_name EdgeData

static var next_id = 0

var id: int
var grid_position: Vector2i
var world_position: Vector2
var world_normal_rotation: float

func _init() -> void:
    id = next_id
    next_id += 1
