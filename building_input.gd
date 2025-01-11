class_name BuildingInput extends Node2D

enum SelectedTool {
  NONE,
  STATION,
  RAIL
}

@export var building_node: Node

@onready var ghost = $GhostStation as Sprite2D

var tool_orientation := 0

var selected_tool: SelectedTool = SelectedTool.NONE

var selected_station: Station = null

func _process(_delta: float) -> void:
    ghost.visible = selected_tool == SelectedTool.STATION

    match selected_tool:
        SelectedTool.STATION:
            ghost.rotation = tool_orientation * PI / 2
            ghost.global_position = (get_global_mouse_position() / Station.SIZE).round() * Station.SIZE

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("rotate_tool"):
        tool_orientation += 1
        tool_orientation %= 4

    if event.is_action_pressed("counter_rotate_tool"):
        tool_orientation -= 1
        tool_orientation %= 4

    if event.is_action_pressed("cancel_tool"):
        selected_tool = SelectedTool.NONE

    if event.is_action_pressed("place_tool"):
        match selected_tool:
            SelectedTool.STATION:
                if get_station_at_location(ghost.global_position) == null:
                    var station = preload("res://station/station.tscn").instantiate() as Station
                    station.position = ghost.global_position
                    station.rotation = tool_orientation * PI / 2
                    building_node.add_child(station)

            SelectedTool.RAIL:
                var clicked_station = get_station_at_location(get_global_mouse_position())
                if clicked_station != null:
                    if selected_station == null:
                        selected_station = clicked_station
                        selected_station.modulate = Color(1, 0, 0)
                    else:
                        var connection = preload("res://rail_connection/rail_connection.tscn").instantiate() as RailConnection
                        connection.start_station = selected_station
                        connection.end_station = clicked_station
                        building_node.add_child(connection)
                        selected_station.modulate = Color(1, 1, 1)
                        selected_station = null


func _on_station_button_pressed() -> void:
    selected_tool = SelectedTool.STATION

func _on_rail_button_pressed() -> void:
    selected_tool = SelectedTool.RAIL

func get_station_at_location(location: Vector2) -> Station:
    for station in get_tree().get_nodes_in_group("stations"):
        if station.global_position == location:
            return station

    for station: Station in get_tree().get_nodes_in_group("stations"):
        if station.get_rect().has_point(station.to_local(location)):
            return station

    return null
