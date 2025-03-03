class_name TrainSpawner
extends Node

@export var path_finding: PathFinding
@export var rail_grid: RailGrid
@export var on_rails: Node2D

var train_scene = preload("res://train/train.tscn")

func _ready() -> void:
    # Wait a frame to make sure edges are populated
    await get_tree().process_frame

    # Spawn 10 trains on random edges
    for i in range(10):
        spawn_train_on_random_edge()

func spawn_train_on_random_edge() -> void:
    var edges = rail_grid.get_edges()
    if edges.size() > 0:
        var edge = edges.pick_random()

        var train = train_scene.instantiate()
        train.position = edge.get_edge().world_position
        train.rotation = Direction.get_rotation(edge.direction)
        train.current_node = edge
        train.rail_grid = rail_grid
        train.path_finding = path_finding

        on_rails.add_child(train)
