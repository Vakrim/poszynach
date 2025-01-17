class_name Train
extends Node2D

var path_finding: PathFinding

var rail_grid: RailGrid

var current_node: Edge.WithDirection

var current_target: Edge.WithDirection

var speed = 75

var path: PackedVector2Array = PackedVector2Array()

func _process(delta: float) -> void:
    if path.size() == 0:
        if current_target != null:
            current_node = current_target

        find_new_target()
        return

    var target = path[0]

    var direction = target - self.global_position
    var distance = direction.length()

    if distance < speed * delta:
        position = target
        path.remove_at(0)
        return

    var velocity = direction.normalized() * speed
    position += velocity * delta
    rotation = Vector2.RIGHT.rotated(rotation).slerp(direction.normalized(), 0.1).angle()

    if rotation_degrees < -90 or rotation_degrees > 90:
        scale = Vector2(1, -1)
    else:
        scale = Vector2(1, 1)

func find_new_target() -> void:
    current_target = rail_grid.get_edges().pick_random()

    path = path_finding.find_path(current_node, current_target)

    if path.size() == 0:
        current_target = null
        return
