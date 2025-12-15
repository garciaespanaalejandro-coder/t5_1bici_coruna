class station_status {
  final int stationId;
  final String name;
  final int bikes_available;
  final int docks_available;
  final int fitBikes_available;
  final int efitBikes_available;
  final int boostBikes_available;

  station_status({
    required this.stationId,
    required this.name,
    required this.bikes_available,
    required this.docks_available,
    required this.fitBikes_available,
    required this.efitBikes_available,
    required this.boostBikes_available,
  });

  factory station_status.fromJson(Map<String, dynamic> json){
    int fitBikes = 0;
    int efitBikes = 0;
    int boostBikes = 0;

    if(json['vehicle_types_available']!=null){
      var vehicleList = json['vehicle_types_available'] as List;

      for (dynamic v in vehicleList){
        final typeId = v['vehicle_type_id'];
        final count = v['count'] as int;

        if(typeId == 'FIT'){
          fitBikes+=count;
        }else if(typeId== 'BOOST'){
          boostBikes+=count;
        }else if(typeId=='EFIT'){
          efitBikes+=count;
        }
      }
    }

    return station_status(
      stationId: int.parse(json['station_id']),
      name: json['name'] ?? '',
      bikes_available: json['num_bikes_available'] ?? 0,
      docks_available: json['num_docks_available'] ?? 0,
      fitBikes_available: fitBikes,
      efitBikes_available: efitBikes,
      boostBikes_available: boostBikes,
    );
  }

  

}