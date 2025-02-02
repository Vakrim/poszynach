class_name Logistic
extends Node

func _process(_delta: float) -> void:
    var stations = get_tree().get_nodes_in_group("stations") as Array[Station]

    var expected_requests = floori(stations.size() * 0.6)

    var transport_requests = []

    for station in stations:
        transport_requests.append_array(station.transport_requests)

    if transport_requests.size() < expected_requests:
        var station = stations.pick_random()

        stations.erase(station)

        var other_station = stations.pick_random()

        var transport_request = TransportRequest.new()
        transport_request.destination = other_station
        transport_request.source = station

        station.transport_requests.append(transport_request)
