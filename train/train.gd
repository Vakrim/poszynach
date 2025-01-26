class_name Train
extends Node2D

var path_finding: PathFinding

var rail_grid: RailGrid

var current_node: Edge.WithDirection

var current_path: Array[Edge.WithDirection] = []

var speed = 75

@onready var follower: PathFollow2D = %Follower
@onready var train_path: Path2D = %TrainPath

func _process(delta: float) -> void:
    if current_path.size() == 0:
        find_new_target()
        return

    var distance_to_travel = speed * delta

    if follower.progress + distance_to_travel >= train_path.curve.get_baked_length():
        current_node = current_path[-1]
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
    var target = rail_grid.get_edges().pick_random()
    navigate_to(target)

func navigate_to(target: Edge.WithDirection) -> void:
    var curve = Curve2D.new()

    current_path = path_finding.find_path(current_node, target)

    for i in range(current_path.size()):
        var point = current_path[i].get_edge().world_position

        var direction = Direction.get_vec(current_path[i].direction) * 40

        curve.add_point(point, -direction, direction)

    train_path.curve = curve
    follower.progress = 0

    if current_path.size() == 0:
        return
