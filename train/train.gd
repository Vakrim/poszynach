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
    const MIN_IDLE_TIME = 1.0
    var idle_timer := 0.0

    func update(delta: float) -> void:
        idle_timer += delta
        if idle_timer < MIN_IDLE_TIME:
            return

        var target = find_nearest_station_with_transport_request()

        if !target:
            idle_timer = 0
            return

        actor.change_state(GrabItemFromStationState.new(target))

    func find_nearest_station_with_transport_request() -> Station:
        var stations = actor.get_tree().get_nodes_in_group('stations')

        var nearest_station: Station = null
        var min_distance = 10000

        for station in stations:
            if station.transport_requests.size() == 0:
                continue

            var distance = actor.find_path_to(station.edge).size()

            if distance > 0 and distance < min_distance:
                min_distance = distance
                nearest_station = station

        return nearest_station

class Moving:
    var actor: Train
    var target: Edge.WithDirection
    var current_path: Array[Edge.WithDirection] = []
    var speed = 0.0
    const BRAKING_TIME := 1.0 # seconds
    const MAX_SPEED := 100.0 # pixels per second
    const CRUISING_SPEED := 5.0 # pixels per second

    func _init(actor_: Train, target_: Edge.WithDirection) -> void:
        self.actor = actor_
        self.target = target_

    func update(delta: float, on_target_reached: Callable) -> void:
        if current_path.size() == 0:
            current_path = actor.find_path_to(target)
            if current_path.size() == 0:
                return
            actor.navigate_path(current_path)

        var distance_to_reach_target = actor.train_path.curve.get_baked_length() - actor.follower.progress;

        var target_speed = MAX_SPEED if distance_to_reach_target > speed * BRAKING_TIME else CRUISING_SPEED

        speed = lerp(speed, target_speed, delta)

        var distance_traveled_this_frame = speed * delta

        if distance_to_reach_target <= distance_traveled_this_frame:
            actor.current_node = current_path[-1]
            on_target_reached.call()
            return

        actor.follower.progress += distance_traveled_this_frame

        actor.position = actor.follower.global_position
        actor.rotation = actor.follower.rotation

class GrabItemFromStationState extends State:
    var station: Station
    var item: TransportRequest
    var moving: Moving

    func _init(station_: Station) -> void:
        self.station = station_

    func enter() -> void:
        moving = Moving.new(actor, station.edge)
        item = station.transport_requests.pop_front()

    func update(delta: float) -> void:
        moving.update(delta, self.reached_station)

    func reached_station() -> void:
        actor.change_state(DropItemAtStationState.new(item))

class DropItemAtStationState extends State:
    var item: TransportRequest
    var moving: Moving

    func _init(item_: TransportRequest) -> void:
        self.item = item_

    func enter() -> void:
        moving = Moving.new(actor, item.destination.edge)

    func update(delta: float) -> void:
        moving.update(delta, self.reached_station)

    func reached_station() -> void:
        actor.change_state(IdleState.new())
