class station_information {

  final int stationId;
  final String name;
  final int capacity;
  final double lat;
  final double lon;

  station_information({
    required this.stationId,
    required this.name,
    required this.capacity,
    required this.lat,
    required this.lon,
  
  });

  factory station_information.fromJson(Map<String, dynamic> json){
    return station_information(
      stationId: int.tryParse(json['stationId'].toString()) ??0,
      name: (json['name']?? '') as String,
      capacity: int.tryParse(json['capacity'].toString()) ??0,
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }

}