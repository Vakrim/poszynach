class_name RailConnection
extends Path2D

@export var start_station: Station:
    set(new_station):
        start_station = new_station
        update_connection()

@export var end_station: Station:
    set(new_station):
        end_station = new_station
        update_connection()

@export var station_entrance_length: float = 50:
    set(new_length):
        station_entrance_length = new_length
        update_connection()

func update_connection() -> void:
    if !start_station || !end_station:
        return

    curve.clear_points()

    var start_station_step = Vector2.from_angle(start_station.rotation) * station_entrance_length

    curve.add_point(start_station.global_position)

    curve.add_point(start_station.global_position + start_station_step, Vector2.ZERO, start_station_step)

    var end_station_step = Vector2.from_angle(end_station.rotation + PI) * station_entrance_length

    curve.add_point(end_station.global_position + end_station_step, end_station_step, Vector2.ZERO)

    curve.add_point(end_station.global_position)

    if $ConnectionLine:
        $ConnectionLine.points = curve.get_baked_points()

func _ready() -> void:
    update_connection()
