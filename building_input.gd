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

func _process(_delta: float) -> void:
    ghost.visible = selected_tool == SelectedTool.STATION

    match selected_tool:
        SelectedTool.STATION:
            ghost.rotation = tool_orientation * PI / 2

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        match selected_tool:
            SelectedTool.STATION:
                ghost.global_position = (get_global_mouse_position() / Station.SIZE).round() * Station.SIZE

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
                else:
                    print("Station already exists at this location")

func _on_station_button_pressed() -> void:
    selected_tool = SelectedTool.STATION

func _on_rail_button_pressed() -> void:
    selected_tool = SelectedTool.RAIL

func get_station_at_location(location: Vector2) -> Station:
    for station in get_tree().get_nodes_in_group("stations"):
        if station.position == location:
            return station
    return null
