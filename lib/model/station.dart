class Station {
  final int id;
  final String name;
  final double lat;
  final double lon;
  final int bikesAvailable;
  final int fitBikesAvailable;
  final int ebikesAvailable;
  final int boostAvailable;
  final int docksAvailable;
  final DateTime lastUpdated;
  final String direccion;

  Station({
    required this.boostAvailable, 
    required this.fitBikesAvailable,
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.bikesAvailable,
    required this.ebikesAvailable,
    required this.docksAvailable,
    required this.lastUpdated,
    required this.direccion
  });
}