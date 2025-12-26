class station_status {
  final int stationId;
  final int bikesAvailable;
  final int docksAvailable;
  final int fitBikesAvailable;
  final int efitBikesAvailable;
  final int boostBikesAvailable;
  final DateTime lastUpdated;

  station_status({
    required this.stationId,
    required this.bikesAvailable,
    required this.docksAvailable,
    required this.fitBikesAvailable,
    required this.efitBikesAvailable,
    required this.boostBikesAvailable,
    required this.lastUpdated,
  });
}