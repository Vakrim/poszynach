@tool
extends Line2D

@export var start_station: Station:
	set(new_station):
		start_station = new_station
		update_connection()
		
@export var end_station: Station:
	set(new_station):
		end_station = new_station
		update_connection()
		
func update_connection() -> void:
	print("connection!")
	if start_station && end_station:
		self.set_points(PackedVector2Array([start_station.get_end().global_position, end_station.get_start().global_position]))

func _ready() -> void:
	print("ready!")
	update_connection()
