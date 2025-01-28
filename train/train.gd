class_name Train
extends Node2D

var path_finding: PathFinding
var rail_grid: RailGrid

var current_node: Edge.WithDirection
var state: State

@onready var follower: PathFollow2D = %Follower
@onready var train_path: Path2D = %TrainPath

func _ready() -> void:
    change_state(IdleState.new())

func _process(delta: float) -> void:
    state.update(delta)

    if rotation_degrees < -90 or rotation_degrees > 90:
        scale = Vector2(1, -1)
    else:
        scale = Vector2(1, 1)

func find_path_to(target: Edge.WithDirection) -> Array[Edge.WithDirection]:
    return path_finding.find_path(current_node, target)

func navigate_path(path: Array[Edge.WithDirection]) -> void:
    var curve = Curve2D.new()

    for i in range(path.size()):
        var point = path[i].get_edge().world_position

        var direction = Direction.get_vec(path[i].direction) * 40

        curve.add_point(point, -direction, direction)

    train_path.curve = curve
    follower.progress = 0

func change_state(new_state: State) -> void:
    if state != null:
        state.exit()

    new_state.actor = self
    state = new_state
    state.enter()

class State:
    var actor: Train

    func enter() -> void:
        pass

    func exit() -> void:
        pass

    func update(_delta: float) -> void:
        pass

class IdleState extends State:
    func update(_delta: float) -> void:
        var target = actor.rail_grid.get_edges().pick_random()

        if (!target):
            return

        actor.change_state(MovingState.new(target))

class MovingState extends State:
    var target = Edge.WithDirection
    var current_path: Array[Edge.WithDirection] = []
    var speed = 0.0
    const BREAKING_TIME = 1.0
    const MAX_SPEED = 100.0
    const CRUISING_SPEED = 5.0

    func _init(target_: Edge.WithDirection) -> void:
        self.target = target_

    func enter() -> void:
        current_path = actor.find_path_to(target)

        if current_path.size() == 0: # No path found
            actor.change_state(IdleState.new())
            return

        actor.navigate_path(current_path)

    func update(delta: float) -> void:
        var distance_to_reach_target = actor.train_path.curve.get_baked_length() - actor.follower.progress;

        var target_speed = MAX_SPEED if distance_to_reach_target > speed * BREAKING_TIME else CRUISING_SPEED

        speed = lerp(speed, target_speed, delta)

        var distance_traveled_this_frame = speed * delta

        if distance_to_reach_target <= distance_traveled_this_frame:
            actor.current_node = current_path[-1]
            actor.change_state(IdleState.new())
            return

        actor.follower.progress += distance_traveled_this_frame

        actor.position = actor.follower.global_position
        actor.rotation = actor.follower.rotation
