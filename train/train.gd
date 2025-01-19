class_name Train
extends Node2D

var path_finding: PathFinding

var rail_grid: RailGrid

var current_node: Edge.WithDirection

var current_target: Edge.WithDirection

var speed = 75

@onready var follower: PathFollow2D = %Follower
@onready var train_path: Path2D = %TrainPath

func _process(delta: float) -> void:
    if current_target == null:
        find_new_target()
        return

    var distance_to_travel = speed * delta

    if follower.progress + distance_to_travel >= train_path.curve.get_baked_length():
        current_node = current_target
        find_new_target()
        return

    follower.progress += distance_to_travel

    position = follower.global_position
    rotation = follower.rotation

    if rotation_degrees < -90 or rotation_degrees > 90:
        scale = Vector2(1, -1)
    else:
        scale = Vector2(1, 1)

func find_new_target() -> void:
    current_target = rail_grid.get_edges().pick_random()

    var curve = Curve2D.new()

    var path = path_finding.find_path(current_node, current_target)

    for i in range(path.size()):
        var point = path[i].get_edge().world_position

        var direction = Direction.get_vec(path[i].direction) * 40

        curve.add_point(point, -direction, direction)

    train_path.curve = curve
    follower.progress = 0

    if path.size() == 0:
        current_target = null
        return
