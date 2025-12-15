class station_information {

  final int stationId;
  final String name;
  final int capacity;
  final int last_updated;

  station_information({
    required this.stationId,
    required this.name,
    required this.capacity,
    required this.last_updated,
  });

  factory station_information.fromJson(Map<String, dynamic> json) {
    return station_information(
      stationId: (json['station_id'] as num).toInt(),
      name:(json['name'] ?? '') as String,
      capacity: (json['capacity'] as num).toInt(),
      last_updated: (json['last_updated'] as num).toInt()
    );
  }
}