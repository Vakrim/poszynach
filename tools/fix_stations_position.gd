@tool
extends EditorScript

func _run():
  var stations = get_scene().find_children('*', 'Station')
  var edges_grid = get_scene().find_child('EdgesGrid') as EdgesGrid

  for station in stations:
    var station_map_position = edges_grid.local_to_map(edges_grid.to_local(station.global_position))

    if edges_grid.is_tile_center(station_map_position):
      station_map_position = Vector2i(station_map_position.x + 1, station_map_position.y)

    var new_position = edges_grid.to_global(edges_grid.map_to_local(station_map_position))

    station.global_position = new_position

  print('done!')
