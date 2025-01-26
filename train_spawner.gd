class_name TrainSpawner
extends Node

@export var path_finding: PathFinding
@export var rail_grid: RailGrid
@export var on_rails: Node2D

var train_scene = preload("res://train/train.tscn")

var edges_count = 0

func _process(_delta: float) -> void:
    var trains = get_tree().get_nodes_in_group("trains") as Array[Train]

    var stations = get_tree().get_nodes_in_group("stations") as Array[Station]

    if trains.size() * 5 < edges_count:
        var station = stations.pick_random()
        var edge = station.edge

        var train = train_scene.instantiate()
        train.position = edge.get_edge().world_position
        train.rotation = Direction.get_rotation(edge.direction)
        train.current_node = edge
        train.rail_grid = rail_grid
        train.path_finding = path_finding

        on_rails.add_child(train)

func _on_rail_grid_edge_created(_edge: Edge.WithDirection) -> void:
    edges_count += 1

func _on_rail_grid_edge_removed(_edge: Edge.WithDirection) -> void:
    edges_count -= 1
